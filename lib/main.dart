import 'package:bitelogik/data/services/auth_service.dart';
import 'package:bitelogik/data/services/hive_service.dart';
import 'package:bitelogik/routing/router.dart';
import 'package:bitelogik/ui/core/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await Firebase.initializeApp(options:
      DefaultFirebaseOptions.currentPlatform
  // FirebaseOptions(
  //     apiKey: "AIzaSyDH-EtATdQbdOe4OjKC_taU5sXOsV6pbTc",
  //     authDomain: "bitelogik.firebaseapp.com",
  //     projectId: "bitelogik",
  //     storageBucket: "bitelogik.firebasestorage.app",
  //     messagingSenderId: "90875001267",
  //     appId: "1:90875001267:web:838d72cc9d0ece144df3c6")
  );

 AuthService authService = AuthService();
  const String? serverClientId = kIsWeb ? null :"90875001267-2g4uadq7b3f1v6u5n6t1v6u5n6t1v6u5.apps.googleusercontent.com";
  await authService.initialize(
    clientId: '90875001267-2g4uadq7b3f1v6u5n6t1v6u5n6t1v6u5.apps.googleusercontent.com',
    serverClientId: serverClientId,);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRoutes,
      title: 'Flutter Login Counter',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
