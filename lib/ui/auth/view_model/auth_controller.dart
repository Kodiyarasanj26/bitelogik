import 'package:bitelogik/data/services/hive_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/services/auth_service.dart';


final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  Future login(String email, String password) async {
    final loadingNotifier = ref.read(loadingProvider.notifier);
    loadingNotifier.setLoading(true);
    try {
      final svc = ref.read(authServiceProvider);
      await svc.login(email, password);
    } finally {
      loadingNotifier.setLoading(false);
    }
  }

  Future<UserCredential> signup(String email, String password) async {
    final loadingNotifier = ref.read(loadingProvider.notifier);
    loadingNotifier.setLoading(true);
    try {
      final svc = ref.read(authServiceProvider);
      return await svc.signup(email, password);
    } finally {
      loadingNotifier.setLoading(false);
    }
  }

  Future googleSignIn() async {
    final loadingNotifier = ref.read(loadingProvider.notifier);
    loadingNotifier.setLoading(true);
    try {
      final svc = ref.read(authServiceProvider);
      return await svc.signInWithGoogle();
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      rethrow;
    }
    finally {
      loadingNotifier.setLoading(false);
    }
  }

  Future<void> logout() async {
    final svc = ref.read(authServiceProvider);
    await svc.signOut();
    HiveService.clearLogin();
  }
}

final authControllerProvider = Provider<AuthController>((ref) => AuthController(ref));

class LoadingStateNotifier extends StateNotifier<bool> {
  LoadingStateNotifier() : super(false);

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

final loadingProvider = StateNotifierProvider<LoadingStateNotifier, bool>((ref) {
  return LoadingStateNotifier();
});