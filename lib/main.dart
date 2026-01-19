import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/services/local%20storage/storage_service.dart';
import 'package:template/core/themes/themes.dart';
import 'package:template/routes/app_routes.dart';
import 'package:template/routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AI Legal Assistant',
          theme: MyAppThemes.lightThemes,
          initialRoute: RoutesName.splashScreen,
          getPages: AppRoutes.pages,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
      child: const SizedBox(),
    );
  }
}
