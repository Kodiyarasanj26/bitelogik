

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_colors.dart';
import '../../../data/services/hive_service.dart';
import '../../../routing/route_names.dart';
import '../../core/ui/custom_text.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  AnimationController ? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    checkLogin();
  }

  checkLogin()async{
    Future.delayed(const Duration(seconds: 2), () {
      if (HiveService.isLoggedIn()) {
        context.go(RoutePath.homeScreen);
      } else {
        context.go(RoutePath.loginScreen);
      }
    });
  }
   @override
 void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2).animate(
            CurvedAnimation(
              parent: _animationController!,
              curve: Curves.easeInOut,
            ),
          ),
          child: CustomText(
            text: "BiteLogik",
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
      ),
    );
  }
}
