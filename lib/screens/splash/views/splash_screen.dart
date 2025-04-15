import 'package:flutter/material.dart';
import 'package:shop/screens/onboarding/views/onboarding_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: OnBoardingScreen(),
      duration: 10000, // 10 giây
      text: "Nguyen Viet An - 21110118\n Tran Viet Trung - 21110859",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      colors: [Colors.blue, Colors.red, Colors.green, Colors.orange],
      backgroundColor: Colors.white,
    );
  }
}
