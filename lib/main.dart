import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_theme.dart';
import 'core/database/db_helper.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkHeaderBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Local Storage & Database
  await StorageService.init();
  await DBHelper().database;
  await NotificationService().init();

  runApp(const Spendly());
}

class Spendly extends StatelessWidget {
  const Spendly({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Spendly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
