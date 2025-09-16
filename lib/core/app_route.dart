
import 'package:app/core/controller_bindings.dart';
import 'package:app/core/widget/subscription_screen.dart';
import 'package:app/feature/Admin/auth/presentation/screen/login_screen.dart';
import 'package:app/feature/Admin/auth/presentation/screen/onboarding_screen.dart';
import 'package:app/feature/Admin/auth/presentation/screen/singup_screen.dart';
import 'package:app/feature/Admin/auth/presentation/screen/splash_screen.dart' show SplashScreen;
import 'package:app/feature/Admin/home/presentation/screen/home_screen.dart';
import 'package:app/feature/Admin/navigation.dart';
import 'package:app/feature/Admin/notification/presentation/screen/notification_screen.dart';

import 'package:app/feature/Admin/profile/presentation/screen/create_admin.dart';
import 'package:app/feature/Admin/profile/presentation/widget/admin_splash_screen.dart';
import 'package:app/feature/SuperAdmin/admin/presentaion/screen/super_admin.dart';
import 'package:app/feature/User/home/presentation/screen/home_screen.dart';
import 'package:app/feature/User/navigation.dart';
import 'package:app/feature/User/profile/presentation/widget/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ServiceApp extends StatefulWidget {
  const ServiceApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<ServiceApp> createState() => _ServiceAppState();
}

class _ServiceAppState extends State<ServiceApp> {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
     


      navigatorKey: ServiceApp.navigatorKey,
      initialBinding: ControllerBinding(),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      getPages: [
GetPage(name: "/splash_screen", page: ()=>SplashScreen()),
        GetPage(name: "/onboarding_screen", page: ()=>OnboardingScreen()),
        GetPage(name: "/login", page: ()=>LoginScreen()),
        GetPage(name: "/edit_userprofile", page:()=> EditUserProfileScreen()),
        GetPage(name: "/signup", page: ()=>SignupScreen()),
        GetPage(name: "/home_admin", page:()=>HomeScreenAdmin()),
        GetPage(name: "/navigation", page: ()=>CustomNavigationScreen()),
        GetPage(name: "/admin_profile", page: ()=>CreateAdmin()),
        GetPage(name: "/worker_reg", page: ()=>AdminSplashScreen()),
        GetPage(name: "/subscription", page: ()=>SubscriptionScreen()),

        GetPage(
          name: "/order",
          page: () {

            return AdminOrdersScreen();
          },
        ),

GetPage(name: "/admin_dashboard", page: ()=>AdminListScreen()),
        GetPage(name: "/user_home", page: ()=>UserHomeScreen()),
        GetPage(name: "/user_navigation", page: ()=>CustomUserNavigationScreen())
      ],
    );
  }
}
