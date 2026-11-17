package com.cavernlabs.social.bridge.social_bridge

import android.app.Activity
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.OAuthCredential
import com.google.firebase.auth.OAuthProvider
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await

/*
 * Handles Apple Sign-In using Firebase Auth OAuthProvider.
 */
class AppleAuthHandler(
    private val scope: CoroutineScope = CoroutineScope(Dispatchers.Main)
) {

    fun signIn(
        activity: Activity,
        scopes: List<String>?,
        result: Result
    ) {
        scope.launch {
            try {
                if (FirebaseApp.getApps(activity).isEmpty()) {
                    result.error(
                        "FIREBASE_NOT_INITIALIZED",
                        "Apple Sign-In on Android requires Firebase Authentication. Please add google-services.json to your app.",
                        null
                    )
                    return@launch
                }

                val auth = FirebaseAuth.getInstance()
                val providerBuilder = OAuthProvider.newBuilder("apple.com").apply {
                    this.scopes = scopes ?: listOf("email", "name")
                }

                val authResult = auth.startActivityForSignInWithProvider(
                    activity,
                    providerBuilder.build()
                ).await()

                val user = authResult.user
                val credential = authResult.credential as? OAuthCredential

                val authData = mapOf(
                    "provider" to "apple",
                    "idToken" to credential?.idToken,
                    "accessToken" to credential?.accessToken,
                    "email" to user?.email,
                    "displayName" to user?.displayName,
                    "photoUrl" to user?.photoUrl?.toString(),
                    "userIdentifier" to user?.uid
                )
                result.success(authData)
            } catch (e: Exception) {
                val message = e.localizedMessage ?: "Apple Sign-In failed."
                val code = if (message.contains("cancel", ignoreCase = true)) {
                    "CANCELLED"
                } else {
                    "FAILED"
                }
                result.error(code, message, null)
            }
        }
    }
}
