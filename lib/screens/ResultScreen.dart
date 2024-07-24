import 'package:business_trip/screens/CharacterChoiceScreen.dart';
import 'package:flutter/material.dart';


class ResultScreen extends StatefulWidget {
  final int selectedIndex; // RandomPickerScreen으로부터 전달받은 int 파라미터
  ResultScreen({required this.selectedIndex}); // 생성자에서 파라미터를 받음

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final List<String> spacecraftImages = List.generate(12, (index) => 'assets/result/spacecraft_${index + 1}.png');

  bool _isButtonPressed = false; // 버튼이 눌렸는지 여부

  void _navigateToCharacterChoiceScreen() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterChoiceScreen(),
        ), (Route<dynamic> route) => false, // 이전 페이지 스택을 모두 제거
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 전체 화면 크기의 배경 이미지뷰
          Positioned.fill(
            child: Image.asset(
              'assets/result/background.png', // 적절한 경로로 변경
              fit: BoxFit.cover,
            ),
          ),
          // ㅊㅋㅊㅋ
          Positioned(
            bottom: 2 * MediaQuery.of(context).size.height / 10 + MediaQuery.of(context).size.height / 2,
            left: 0,
            right: 10,
            height: MediaQuery.of(context).size.height / 10,
            child: Align(
              alignment: Alignment.centerRight,
              child: AspectRatio(
                aspectRatio: 764 / 231,
                child: Image.asset(
                  'assets/result/congratulations.png', // 적절한 경로로 변경
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // 결과 로켓
          Positioned(
            bottom: 2 * MediaQuery.of(context).size.height / 10,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                spacecraftImages[widget.selectedIndex], // 적절한 경로로 변경
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 잘 다녀오세요!
          Positioned(
            bottom: MediaQuery.of(context).size.height / 10 + 20,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 10,
            child: Image.asset(
              'assets/result/bye.png', // 적절한 경로로 변경
              fit: BoxFit.contain,
            ),
          ),
          // 다시하기 버튼
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            height: _isButtonPressed ? MediaQuery.of(context).size.height / 11 : MediaQuery.of(context).size.height / 10, // 스택 컨테이너의 1/10
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isButtonPressed = true),
              onTapUp: (_) => setState(() => _isButtonPressed = false),
              onTapCancel: () => setState(() => _isButtonPressed = false),
              onTap: _navigateToCharacterChoiceScreen, // 버튼 클릭 시 캐릭터 선택화면으로 이동
              child: Image.asset(
                'assets/result/restart.png',
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }
}