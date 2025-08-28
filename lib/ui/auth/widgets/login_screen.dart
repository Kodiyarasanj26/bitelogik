import 'package:bitelogik/data/services/hive_service.dart';
import 'package:bitelogik/routing/route_names.dart';
import 'package:bitelogik/ui/core/ui/app_button.dart';
import 'package:bitelogik/ui/core/ui/app_loader.dart';
import 'package:bitelogik/ui/core/ui/custom_text_field.dart';
import 'package:bitelogik/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../config/app_colors.dart';
import '../../core/ui/custom_text.dart';
import '../view_model/auth_controller.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(authControllerProvider).login(
        emailController.text.trim(),
        passwordController.text,
      );
      if (mounted && FirebaseAuth.instance.currentUser != null) {
        HiveService.saveLoginState(true);
        context.go(RoutePath.homeScreen);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'invalid-credential':
          message = 'Invalid credentials. Please check your email and password.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        default:
          message = 'An unknown Firebase error occurred: ${e.message}';
          break;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An unexpected error occurred: ${e.toString()}")),
        );
        print("Error during email/password login: $e");
      }
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final userCred = await ref.read(authServiceProvider).signInWithGoogle();

      if (userCred != null && mounted) {
        HiveService.saveLoginState(true);
        context.go(RoutePath.homeScreen);
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-in cancelled.")),
        );
      }
    } on FirebaseAuthException catch (e, st) {
      // Firebase-specific issues (show friendly messages)
      final message = switch (e.code) {
        'account-exists-with-different-credential' =>
        'An account already exists with the same email address but different sign-in credentials.',
        'credential-already-in-use' =>
        'The provided Google credential is already associated with an existing user.',
        _ => 'Firebase error during sign-in: ${e.message ?? e.code}',
      };

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      print('FirebaseAuthException: ${e.code} -> ${e.message}');
      print(st);
    } on GoogleSignInException catch (e, st) {
      // Should be rare because signInWithGoogle handles 'canceled', but keep safe fallback:
      if (e.code == GoogleSignInExceptionCode.canceled) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Google sign-in cancelled.")));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed: ${e.details ?? e.code}')));
        print('GoogleSignInException: ${e.code} -> ${e.details}${e.description}');
        print(st);
      }
    } catch (e, st) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unexpected error during Google sign-in: ${e.toString()}")));
      print('Unknown sign-in error: $e');
      print(st);
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  CustomText(
                    text: "Welcome to Bitelogik",
                    fontSize: 24,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  40.height,
                  CustomText(
                    text: "Login to your account",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.left,
                  ),
                  40.height,
                  CustomTextField(
                    controller: emailController,
                    hint: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address.';
                      }
                      return null;
                    },
                  ),
                  10.height,
                  CustomTextField(
                    controller: passwordController,
                    hint: "Password",
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password.';
                      }
                      return null;
                    },
                  ),
                  20.height,
                  if (isLoading) AppLoader()
                  else
                  AppButton(onPressed: loginUser,text:  "Login"),
                 10.height,
                  ElevatedButton.icon(
                    onPressed: loginWithGoogle,
                    icon:  Image.asset(
                      'assets/google_logo.png',
                      height: 24,
                      width: 24,
                    ),
                    label: CustomText(text: "Sign in with Google"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePath.signupScreen),
                    child: CustomText(text: "Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
