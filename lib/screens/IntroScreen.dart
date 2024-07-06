import 'package:flutter/material.dart';
import 'package:business_trip/screens/MainScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 자동으로 다음 화면으로 전환
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 700),  // 애니메이션 지속 시간을 1초로 설정
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/intro_image.png',
          fit: BoxFit.cover,  // 이미지를 화면에 꽉 채우기 위해 BoxFit.cover 사용
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}