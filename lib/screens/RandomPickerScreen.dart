import 'package:flutter/material.dart';
import 'dart:async'; // Timer를 사용하기 위한 import
import 'package:business_trip/screens/ResultScreen.dart';
import 'dart:math';

class RandomPickerScreen extends StatefulWidget {
  final List<int> selectedIndices; // 선택된 아이템의 인덱스를 받기 위한 파라미터

  RandomPickerScreen({required this.selectedIndices});

  @override
  _RandomPickerScreenState createState() => _RandomPickerScreenState();
}

class _RandomPickerScreenState extends State<RandomPickerScreen> {
  final List<String> spacecraftImages = List.generate(12, (index) => 'assets/random_picker/spacecraft_${index + 1}.png');
  final List<String> countImages = List.generate(5, (index) => 'assets/random_picker/count_${index + 1}.png');

  int _countdown = 5; // 카운트다운 초기 값
  int _index = 0;
  late Timer _timer; // Timer 인스턴스
  late Timer _randomTimer; // Timer 인스턴스
  bool _isButtonPressed = false; // 버튼이 눌렸는지 여부

  @override
  void initState() {
    super.initState();
    _startCountdown(); // 카운트다운 시작
    _startSpacecraftImageChanger();
  }

  int _getRandomSpacecraftIndex() {
    final random = Random();
    int randomIndex = random.nextInt(widget.selectedIndices.length);

    return widget.selectedIndices[randomIndex];
  }

  // 카운트다운을 시작하고 1초마다 카운트를 감소시킴
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer.cancel(); // 타이머 중지
        _randomTimer.cancel(); // 타이머 중지

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(selectedIndex: _getRandomSpacecraftIndex()), // 선택된 인덱스를 전달
          ),
        );
      }
    });
  }

  void _startSpacecraftImageChanger() {
    _randomTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _index = (_index + 1) % widget.selectedIndices.length;
      });
    });
  }

  void _skip() {
    _timer.cancel(); // 타이머 중지
    _randomTimer.cancel(); // 타이머 중지

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(selectedIndex: _getRandomSpacecraftIndex()), // 선택된 인덱스를 전달
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 해제
    _randomTimer.cancel(); // 타이머 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 전체 화면 크기의 배경 이미지뷰
          Positioned.fill(
            child: Image.asset(
              'assets/random_picker/background.png', // 적절한 경로로 변경
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // 상단 이미지뷰
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 50, right: 50), // 모든 방향에 10의 패딩 적용
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 735 / 192, // AspectRatio 조정 (너비 / 높이)
                      child: Image.asset(
                        'assets/random_picker/who_is.png', // 적절한 경로로 변경
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // 하단 스택 컨테이너
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    // 스택 컨테이너와 크기가 같은 이미지뷰
                    Positioned.fill(
                      child: Image.asset(
                        spacecraftImages[widget.selectedIndices[_index]], // 적절한 경로로 변경
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 최하단 이미지뷰 바로 위에 얹어질 이미지뷰 (카운트다운 표시)
                    Positioned(
                      bottom: MediaQuery.of(context).size.height / 15 + 20, // 최하단 이미지뷰 위에 위치
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height / 6, // 스택 컨테이너의 1/6
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 359 / 368,
                          child: Image.asset(
                            countImages[_countdown - 1], // 카운트에 맞는 이미지
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // 최하단에 배치될 이미지뷰
                    Positioned(
                      bottom: 20, // 최하단 이미지뷰 위에 위치
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height / 15, // 스택 컨테이너의 1/15
                      child: Center(
                        child: GestureDetector(
                          onTapDown: (_) => setState(() => _isButtonPressed = true),
                          onTapUp: (_) => setState(() => _isButtonPressed = false),
                          onTapCancel: () => setState(() => _isButtonPressed = false),
                          onTap: _skip, // skip 버튼 클릭 시 타이머 중지 및 페이지 전환
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 0), // 애니메이션 지속 시간
                            height: _isButtonPressed ? MediaQuery.of(context).size.height / 17 : MediaQuery.of(context).size.height / 15,
                            child: AspectRatio(
                              aspectRatio: 289 / 115,
                              child: Image.asset(
                                'assets/random_picker/skip.png', // 적절한 경로로 변경
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}