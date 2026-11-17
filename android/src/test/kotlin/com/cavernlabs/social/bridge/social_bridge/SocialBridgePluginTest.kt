package com.cavernlabs.social.bridge.social_bridge

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

/*
 * Unit tests for SocialBridgePlugin method call handling.
 */
internal class SocialBridgePluginTest {
    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = SocialBridgePlugin()

        val call = MethodCall("unknownMethod", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).notImplemented()
    }

    @Test
    fun onMethodCall_signInWithGoogle_withoutActivity_returnsNoActivityError() {
        val plugin = SocialBridgePlugin()

        val call = MethodCall("signInWithGoogle", mapOf("serverClientId" to "test-client-id"))
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).error(
            Mockito.eq("NO_ACTIVITY"),
            Mockito.anyString(),
            Mockito.isNull()
        )
    }

    @Test
    fun onMethodCall_signInWithApple_withoutActivity_returnsNoActivityError() {
        val plugin = SocialBridgePlugin()

        val call = MethodCall("signInWithApple", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).error(
            Mockito.eq("NO_ACTIVITY"),
            Mockito.anyString(),
            Mockito.isNull()
        )
    }
}
