// lib/services/auth_service.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google;

  GoogleSignInAccount? _lastAccount;
  late final StreamSubscription _eventsSub;

  AuthService({GoogleSignIn? google}) : _google = google ?? GoogleSignIn.instance {
    _eventsSub = _google.authenticationEvents.listen((event) {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        _lastAccount = event.user;
      } else if (event is GoogleSignInAuthenticationEventSignOut) {
        _lastAccount = null;
      }
    });
  }

  /// Initialize the plugin. Pass your Web OAuth Client ID as serverClientId.
  Future<void> initialize({
    String? clientId,
    String? serverClientId,
    String? hostedDomain,
    String? nonce,
  }) async {
    await _google.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
      hostedDomain: hostedDomain,
      nonce: nonce,
    );

    try {
      await _google.attemptLightweightAuthentication();
    } catch (_) {
      // Not critical
    }
  }

  /// Sign in with Google.
  /// Returns a UserCredential on success, or null if the user cancelled.
  Future<UserCredential?> signInWithGoogle() async {
    try {

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw StateError(
            'Interactive sign-in not supported on this platform via authenticate(). '
                'On web you must use the google_sign_in_web renderButton or the JS SDK flow.'
        );
      }

      final GoogleSignInAccount? account = await _google.authenticate();

      if (account == null) return null;

      _lastAccount = account;

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      final String? accessToken = await requestAccessToken(
        scopes: ['email', 'profile'],
      );

      if (idToken == null) {
        throw StateError('Missing idToken from Google Sign-In.');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<String?> requestAccessToken({List<String> scopes = const []}) async {
    final acct = _lastAccount;
    if (acct == null) return null;

    final existing = await acct.authorizationClient.authorizationForScopes(scopes);
    final authz = existing ?? await acct.authorizationClient.authorizeScopes(scopes);
    return authz?.accessToken;
  }

  Future<void> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signup(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _google.signOut();
    } catch (_) {}
    _lastAccount = null;
  }

  void dispose() => _eventsSub.cancel();
}



