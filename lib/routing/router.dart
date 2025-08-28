
import 'package:bitelogik/routing/route_names.dart';
import 'package:go_router/go_router.dart';
import '../ui/auth/widgets/login_screen.dart';
import '../ui/auth/widgets/signup_screen.dart';
import '../ui/auth/widgets/splash_screen.dart';
import '../ui/dashboard/widgets/home_screen.dart';


 GoRouter appRoutes = GoRouter(
initialLocation: RoutePath.splashScreen,
routes: [
  GoRoute(
      path: RoutePath.splashScreen,
      name: RouteNames.splashScreen,
      builder: (context, state) {
        return const SplashScreen();
      }),
  GoRoute(
      path: RoutePath.loginScreen,
      name: RouteNames.loginScreen,
      builder: (context, state) {
        return const LoginScreen();
      }),
  GoRoute(
      path: RoutePath.signupScreen,
      name: RouteNames.signupScreen,
      builder: (context, state) {
        return const SignupScreen();
      }),
  GoRoute(
      path: RoutePath.homeScreen,
      name: RouteNames.homeScreen,
      builder: (context, state) {
        return const HomeScreen();
      }),
]
 );