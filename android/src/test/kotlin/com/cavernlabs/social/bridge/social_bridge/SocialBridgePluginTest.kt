package com.cavernlabs.social.bridge.social_bridge

import kotlinx.coroutines.runBlocking
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

/*
 * Unit tests for SocialBridgePlugin Pigeon host API handling.
 */
internal class SocialBridgePluginTest {
    @Test
    fun signInWithGoogle_withoutActivity_throwsFlutterError() {
        val plugin = SocialBridgePlugin()
        val request = GoogleSignInRequest(
            serverClientId = "test-client-id",
            nonce = null,
            filterByAuthorizedAccounts = false
        )

        val exception = assertFailsWith<FlutterError> {
            runBlocking {
                plugin.signInWithGoogle(request)
            }
        }
        assertEquals("NO_ACTIVITY", exception.code)
    }

    @Test
    fun signInWithApple_withoutActivity_throwsFlutterError() {
        val plugin = SocialBridgePlugin()
        val request = AppleSignInRequest(scopes = null)

        val exception = assertFailsWith<FlutterError> {
            runBlocking {
                plugin.signInWithApple(request)
            }
        }
        assertEquals("NO_ACTIVITY", exception.code)
    }
}
