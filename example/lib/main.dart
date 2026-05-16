import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nutui_flutter_example/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'NutUI Flutter Demo',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          getPages: Routes.getPages,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFA2C19)),
            scaffoldBackgroundColor: const Color(0xFFF7F8FA),
          ),
        );
      },
    );
  }
}
