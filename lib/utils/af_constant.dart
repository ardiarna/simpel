import 'package:simpel/views/login_page.dart';
import 'package:simpel/views/splash_page.dart';

const String splashRoute = '/splash';
const String loginRoute = '/login';

final afRoutes = {
  splashRoute: (context) => const SplashPage(),
  loginRoute: (context) => const LoginPage(),
};
