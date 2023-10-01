
import 'package:flutter/material.dart';
import 'package:flutter_pagination_api_demo/screens/splashScreen.dart';
import 'utility/appColors.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [RouteObserver()],
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: AppColors.appColor,
      ),
    ),
  );
}
