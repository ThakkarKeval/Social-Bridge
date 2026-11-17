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
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/*
 * Flutter plugin implementation for social authentication.
 */
class SocialBridgePlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null
    private val scope = CoroutineScope(Dispatchers.Main)
    private val googleAuthHandler = GoogleAuthHandler(scope)
    private val appleAuthHandler = AppleAuthHandler(scope)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "social_bridge")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "signInWithGoogle" -> {
                val currentActivity = activity
                if (currentActivity == null) {
                    result.error("NO_ACTIVITY", "Google Sign-In requires an active foreground Activity.", null)
                    return
                }
                val serverClientId = call.argument<String>("serverClientId")
                if (serverClientId.isNullOrBlank()) {
                    result.error("INVALID_ARGUMENT", "serverClientId is required for Google Sign-In.", null)
                    return
                }
                val nonce = call.argument<String>("nonce")
                val filterByAuthorizedAccounts = call.argument<Boolean>("filterByAuthorizedAccounts") ?: false
                googleAuthHandler.signIn(
                    activity = currentActivity,
                    serverClientId = serverClientId,
                    nonce = nonce,
                    filterByAuthorizedAccounts = filterByAuthorizedAccounts,
                    result = result
                )
            }
            "signInWithApple" -> {
                val currentActivity = activity
                if (currentActivity == null) {
                    result.error("NO_ACTIVITY", "Apple Sign-In requires an active foreground Activity.", null)
                    return
                }
                val scopes = call.argument<List<String>>("scopes")
                appleAuthHandler.signIn(
                    activity = currentActivity,
                    scopes = scopes,
                    result = result
                )
            }
            "signOut" -> {
                val currentContext = activity ?: context
                scope.launch {
                    try {
                        if (currentContext != null) {
                            val credentialManager = CredentialManager.create(currentContext)
                            credentialManager.clearCredentialState(ClearCredentialStateRequest())
                            if (FirebaseApp.getApps(currentContext).isNotEmpty()) {
                                FirebaseAuth.getInstance().signOut()
                            }
                        }
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("SIGN_OUT_FAILED", e.localizedMessage ?: "Sign out failed.", null)
                    }
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
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
