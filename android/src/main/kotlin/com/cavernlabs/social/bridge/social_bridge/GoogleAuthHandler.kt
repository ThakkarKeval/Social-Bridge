package com.cavernlabs.social.bridge.social_bridge

import android.app.Activity
import androidx.credentials.CredentialManager
import androidx.credentials.CustomCredential
import androidx.credentials.GetCredentialRequest
import androidx.credentials.exceptions.GetCredentialCancellationException
import androidx.credentials.exceptions.GetCredentialException
import com.google.android.libraries.identity.googleid.GetGoogleIdOption
import com.google.android.libraries.identity.googleid.GoogleIdTokenCredential
import java.security.MessageDigest
import java.util.UUID

/*
 * Handles Google Sign-In using Android Credential Manager.
 */
class GoogleAuthHandler {

    suspend fun signIn(
        activity: Activity,
        request: GoogleSignInRequest
    ): NativeSocialAuthResult {
        try {
            val resolvedNonce = if (request.nonce.isNullOrBlank()) generateNonce() else request.nonce
            val googleIdOption = GetGoogleIdOption.Builder()
                .setFilterByAuthorizedAccounts(request.filterByAuthorizedAccounts)
                .setServerClientId(request.serverClientId)
                .setNonce(resolvedNonce)
                .build()

            val credentialRequest = GetCredentialRequest.Builder()
                .addCredentialOption(googleIdOption)
                .build()

            val credentialManager = CredentialManager.create(activity)
            val response = credentialManager.getCredential(
                request = credentialRequest,
                context = activity
            )

            when (val credential = response.credential) {
                is CustomCredential -> {
                    if (credential.type == GoogleIdTokenCredential.TYPE_GOOGLE_ID_TOKEN_CREDENTIAL) {
                        val googleIdToken = GoogleIdTokenCredential.createFrom(credential.data)
                        return NativeSocialAuthResult(
                            provider = "google",
                            idToken = googleIdToken.idToken,
                            accessToken = null,
                            email = googleIdToken.id,
                            displayName = googleIdToken.displayName,
                            photoUrl = googleIdToken.profilePictureUri?.toString(),
                            userIdentifier = googleIdToken.id
                        )
                    } else {
                        throw FlutterError(
                            "UNSUPPORTED_CREDENTIAL",
                            "Unexpected credential type: ${credential.type}",
                            null
                        )
                    }
                }
                else -> {
                    throw FlutterError(
                        "UNSUPPORTED_CREDENTIAL",
                        "Credential not recognized",
                        null
                    )
                }
            }
        } catch (e: GetCredentialCancellationException) {
            throw FlutterError("CANCELLED", "User cancelled Google Sign-In.", null)
        } catch (e: GetCredentialException) {
            throw FlutterError("CREDENTIAL_ERROR", e.localizedMessage ?: "Google Sign-In failed.", null)
        } catch (e: FlutterError) {
            throw e
        } catch (e: Exception) {
            throw FlutterError("FAILED", e.localizedMessage ?: "Google Sign-In failed.", null)
        }
    }

    private fun generateNonce(): String {
        val randomBytes = UUID.randomUUID().toString().toByteArray()
        val md = MessageDigest.getInstance("SHA-256")
        return md.digest(randomBytes).joinToString("") { "%02x".format(it) }
    }
}
