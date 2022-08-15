import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/constant.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  DioHelper.init();
  await CacheHelper.init();

  token = CacheHelper.getData(key: 'token');
  print('token is: $token');

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  Widget startWidget;

  if (onBoarding != null) {
    if (token != null) {
      startWidget = ShopLayout();
    } else {
      startWidget = LoginScreen();
    }
  } else {
    startWidget = OnBoardingScreen();
  }
  runApp(MyApp(startWidget));
}

class MyApp extends StatelessWidget {
  MyApp(this.startWidget);
  Widget? startWidget;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getHomeData()
        ..getCategoriesData()
        ..getFavoritesData()
        ..getUserData(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'SHOP APP',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: defaultColor,
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Jannah',
              // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              //   // backgroundColor: Color(0xFF333739),
              //   // elevation: 10.0,
              //   // selectedItemColor: defaultColor,
              //   // unselectedItemColor: Colors.grey,
              //   // type: BottomNavigationBarType.fixed,
              // ),
            ),
            home: startWidget,
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
