import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/splash/views/splash_screen.dart';
import '../../features/security/views/app_lock_screen.dart';
import '../../features/settings/views/security_settings_view.dart';
import '../../features/navigation/views/main_navigation_screen.dart';
import '../../features/export/views/export_view.dart';
import '../../features/savings_goals/views/goals_view.dart';
import '../bindings/initial_binding.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.APP_LOCK,
      page: () => const AppLockScreen(),
    ),
    GetPage(
      name: Routes.SECURITY,
      page: () => const SecuritySettingsView(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainNavigationScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.EXPORT,
      page: () => const ExportView(),
    ),
    GetPage(
      name: Routes.GOALS,
      page: () => const GoalsView(),
    ),
  ];
}
