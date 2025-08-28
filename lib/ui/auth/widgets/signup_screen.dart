import 'package:bitelogik/config/app_colors.dart';
import 'package:bitelogik/routing/route_names.dart';
import 'package:bitelogik/ui/core/ui/app_button.dart';
import 'package:bitelogik/ui/core/ui/app_loader.dart';
import 'package:bitelogik/ui/core/ui/custom_text.dart';
import 'package:bitelogik/ui/core/ui/custom_text_field.dart';
import 'package:bitelogik/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_model/auth_controller.dart';


class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signupUser() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(authControllerProvider).signup(
        emailController.text.trim(),
        passwordController.text,
      );

      if (mounted) {
        context.go(RoutePath.loginScreen);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup successful! Please log in.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'The email address is already in use by another account.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password sign-in is not enabled. Please check your Firebase settings.';
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
      }
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
          padding: const EdgeInsets.all(20.0),
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
                    text: "Create Account",
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
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address.';
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
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                  ),
                  20.height,
                  if (isLoading)
                    const AppLoader()
                  else
                  AppButton(
                    onPressed: signupUser,
                    text:  "Sign Up",
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePath.loginScreen),
                    child: CustomText(text: "Already have an account? Login"),
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
