package com.cavernlabs.social.bridge.social_bridge

import android.app.Activity
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.OAuthCredential
import com.google.firebase.auth.OAuthProvider
import kotlinx.coroutines.tasks.await

/*
 * Handles Apple Sign-In using Firebase Auth OAuthProvider.
 */
class AppleAuthHandler {

    suspend fun signIn(
        activity: Activity,
        request: AppleSignInRequest
    ): NativeSocialAuthResult {
        if (FirebaseApp.getApps(activity).isEmpty()) {
            throw FlutterError(
                "FIREBASE_NOT_INITIALIZED",
                "Apple Sign-In on Android requires Firebase Authentication. Please add google-services.json to your app.",
                null
            )
        }

        try {
            val auth = FirebaseAuth.getInstance()
            val providerBuilder = OAuthProvider.newBuilder("apple.com").apply {
                this.scopes = request.scopes ?: listOf("email", "name")
            }

            val authResult = auth.startActivityForSignInWithProvider(
                activity,
                providerBuilder.build()
            ).await()

            val user = authResult.user
            val credential = authResult.credential as? OAuthCredential

            return NativeSocialAuthResult(
                provider = "apple",
                idToken = credential?.idToken,
                accessToken = credential?.accessToken,
                email = user?.email,
                displayName = user?.displayName,
                photoUrl = user?.photoUrl?.toString(),
                userIdentifier = user?.uid
            )
        } catch (e: Exception) {
            val message = e.localizedMessage ?: "Apple Sign-In failed."
            val code = if (message.contains("cancel", ignoreCase = true)) {
                "CANCELLED"
            } else {
                "FAILED"
            }
            throw FlutterError(code, message, null)
        }
    }
}
