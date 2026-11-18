package com.cavernlabs.social.bridge.social_bridge

import android.app.Activity
import android.content.Context
import androidx.credentials.ClearCredentialStateRequest
import androidx.credentials.CredentialManager
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/*
 * Flutter plugin implementation for social authentication using Pigeon.
 */
class SocialBridgePlugin :
    FlutterPlugin,
    ActivityAware,
    SocialBridgeHostApi {

    private var context: Context? = null
    private var activity: Activity? = null
    private val googleAuthHandler = GoogleAuthHandler()
    private val appleAuthHandler = AppleAuthHandler()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        SocialBridgeHostApi.setUp(flutterPluginBinding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        SocialBridgeHostApi.setUp(binding.binaryMessenger, null)
        context = null
    }

    override suspend fun signInWithGoogle(request: GoogleSignInRequest): NativeSocialAuthResult {
        val currentActivity = activity
            ?: throw FlutterError("NO_ACTIVITY", "Google Sign-In requires an active foreground Activity.", null)
        if (request.serverClientId.isBlank()) {
            throw FlutterError("INVALID_ARGUMENT", "serverClientId is required for Google Sign-In.", null)
        }
        return googleAuthHandler.signIn(currentActivity, request)
    }

    override suspend fun signInWithApple(request: AppleSignInRequest): NativeSocialAuthResult {
        val currentActivity = activity
            ?: throw FlutterError("NO_ACTIVITY", "Apple Sign-In requires an active foreground Activity.", null)
        return appleAuthHandler.signIn(currentActivity, request)
    }

    override suspend fun signOut() {
        val currentContext = activity ?: context
        if (currentContext != null) {
            val credentialManager = CredentialManager.create(currentContext)
            credentialManager.clearCredentialState(ClearCredentialStateRequest())
            if (FirebaseApp.getApps(currentContext).isNotEmpty()) {
                FirebaseAuth.getInstance().signOut()
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
