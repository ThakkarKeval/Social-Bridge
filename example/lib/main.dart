import 'package:flutter/material.dart';
import 'package:social_bridge/social_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _socialBridge = const SocialBridge();
  String _status = 'Ready to authenticate';
  SocialAuthResult? _authResult;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _status = 'Starting Google Sign-In...');
    try {
      final result = await _socialBridge.signInWithGoogle(
        serverClientId: '764451121814-ma1671l52nlu5ss4gv0ftlgdt12up54e.apps.googleusercontent.com',
      );
      setState(() {
        _authResult = result;
        _status = 'Signed in with Google: ${result.email}';
      });
    } on SocialAuthCancelledException {
      setState(() => _status = 'Google Sign-In was cancelled.');
    } catch (e) {
      setState(() => _status = 'Google Sign-In error: $e');
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _status = 'Starting Apple Sign-In...');
    try {
      final result = await _socialBridge.signInWithApple();
      setState(() {
        _authResult = result;
        _status = 'Signed in with Apple: ${result.email ?? result.userIdentifier}';
      });
    } on SocialAuthCancelledException {
      setState(() => _status = 'Apple Sign-In was cancelled.');
    } catch (e) {
      setState(() => _status = 'Apple Sign-In error: $e');
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _socialBridge.signOut();
      setState(() {
        _authResult = null;
        _status = 'Signed out successfully.';
      });
    } catch (e) {
      setState(() => _status = 'Sign-out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Social Bridge Example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_authResult != null) ...[
                Text('Provider: ${_authResult!.provider}'),
                Text('Email: ${_authResult!.email ?? "N/A"}'),
                Text('Display Name: ${_authResult!.displayName ?? "N/A"}'),
                Text('ID Token: ${_authResult!.idToken?.substring(0, 20)}...'),
                const SizedBox(height: 16),
              ],
              ElevatedButton.icon(
                onPressed: _handleGoogleSignIn,
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _handleAppleSignIn,
                icon: const Icon(Icons.apple),
                label: const Text('Sign in with Apple'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _handleSignOut,
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
