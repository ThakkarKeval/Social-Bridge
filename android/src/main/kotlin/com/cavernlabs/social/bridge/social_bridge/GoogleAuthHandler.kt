package com.cavernlabs.social.bridge.social_bridge

import android.app.Activity
import androidx.credentials.CredentialManager
import androidx.credentials.CustomCredential
import androidx.credentials.GetCredentialRequest
import androidx.credentials.exceptions.GetCredentialCancellationException
import androidx.credentials.exceptions.GetCredentialException
import com.google.android.libraries.identity.googleid.GetGoogleIdOption
import com.google.android.libraries.identity.googleid.GoogleIdTokenCredential
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.security.MessageDigest
import java.util.UUID

/*
 * Handles Google Sign-In using Android Credential Manager.
 */
class GoogleAuthHandler(
    private val scope: CoroutineScope = CoroutineScope(Dispatchers.Main)
) {

    fun signIn(
        activity: Activity,
        serverClientId: String,
        nonce: String?,
        filterByAuthorizedAccounts: Boolean,
        result: Result
    ) {
        scope.launch {
            try {
                val resolvedNonce = if (nonce.isNullOrBlank()) generateNonce() else nonce
                val googleIdOption = GetGoogleIdOption.Builder()
                    .setFilterByAuthorizedAccounts(filterByAuthorizedAccounts)
                    .setServerClientId(serverClientId)
                    .setNonce(resolvedNonce)
                    .build()

                val request = GetCredentialRequest.Builder()
                    .addCredentialOption(googleIdOption)
                    .build()

                val credentialManager = CredentialManager.create(activity)
                val response = credentialManager.getCredential(
                    request = request,
                    context = activity
                )

                when (val credential = response.credential) {
                    is CustomCredential -> {
                        if (credential.type == GoogleIdTokenCredential.TYPE_GOOGLE_ID_TOKEN_CREDENTIAL) {
                            val googleIdToken = GoogleIdTokenCredential.createFrom(credential.data)
                            val authData = mapOf(
                                "provider" to "google",
                                "idToken" to googleIdToken.idToken,
                                "accessToken" to null,
                                "email" to googleIdToken.id,
                                "displayName" to googleIdToken.displayName,
                                "photoUrl" to googleIdToken.profilePictureUri?.toString(),
                                "userIdentifier" to googleIdToken.id
                            )
                            result.success(authData)
                        } else {
                            result.error(
                                "UNSUPPORTED_CREDENTIAL",
                                "Unexpected credential type: ${credential.type}",
                                null
                            )
                        }
                    }
                    else -> {
                        result.error(
                            "UNSUPPORTED_CREDENTIAL",
                            "Credential not recognized",
                            null
                        )
                    }
                }
            } catch (e: GetCredentialCancellationException) {
                result.error("CANCELLED", "User cancelled Google Sign-In.", null)
            } catch (e: GetCredentialException) {
                result.error("CREDENTIAL_ERROR", e.localizedMessage ?: "Google Sign-In failed.", null)
            } catch (e: Exception) {
                result.error("FAILED", e.localizedMessage ?: "Google Sign-In failed.", null)
            }
        }
    }

    private fun generateNonce(): String {
        val randomBytes = UUID.randomUUID().toString().toByteArray()
        val md = MessageDigest.getInstance("SHA-256")
        return md.digest(randomBytes).joinToString("") { "%02x".format(it) }
    }
}
