import 'package:flutter/material.dart';
import 'package:business_trip/screens/CharacterChoiceScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const _introAsset = 'assets/intro/intro_image.png';

  @override
  void initState() {
    super.initState();

    // ✅ 안정화 포인트: 화면이 사라졌다면 내비게이션하지 않도록 mounted 체크
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return; // ← 여기!
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => CharacterChoiceScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔹 최초 깜빡임 방지: intro 이미지를 미리 디코드/캐시
    precacheImage(const AssetImage(_introAsset), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // 노치/인셋 보호
        child: ColoredBox(
          color: Colors.black, // 레터박스 배경(원하는 색으로)
          child: SizedBox.expand(
            child: Image.asset(
              _introAsset,
              fit: BoxFit.contain, // 전체 이미지 보이게 (잘림 방지)
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
