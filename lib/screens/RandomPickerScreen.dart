import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:business_trip/screens/ResultScreen.dart';

class RandomPickerScreen extends StatefulWidget {
  final List<int> selectedIndices; // 선택된 아이템의 인덱스

  const RandomPickerScreen({super.key, required this.selectedIndices});

  @override
  State<RandomPickerScreen> createState() => _RandomPickerScreenState();
}

class _RandomPickerScreenState extends State<RandomPickerScreen> {
  // 에셋 경로
  final List<String> spacecraftImages = List.generate(
    12,
        (i) => 'assets/random_picker/spacecraft_${i + 1}.png',
  );
  final List<String> countImages = List.generate(
    5,
        (i) => 'assets/random_picker/count_${i + 1}.png',
  );

  // 화면 상태
  int _countdown = 5;
  int _index = 0;
  late Timer _timer;
  late Timer _randomTimer;
  bool _isButtonPressed = false;

  // IndexedStack용 - 한 번만 생성해서 재사용
  late final List<Widget> _spacecraftViews;
  late final List<Widget> _countViews;

  @override
  void initState() {
    super.initState();

    // 1) 위젯 리스트 한 번만 생성
    _spacecraftViews = spacecraftImages
        .map((p) => Image.asset(p, fit: BoxFit.contain))
        .toList(growable: false);

    _countViews = countImages
        .map((p) => Image.asset(p, fit: BoxFit.contain))
        .toList(growable: false);

    // 타이머 시작
    _startCountdown();
    _startSpacecraftImageChanger();
  }

  // 1) precacheImage: 첫 노출 전 디코드/메모리 캐시 (깜빡임 방지)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final p in spacecraftImages) {
      precacheImage(AssetImage(p), context);
    }
    for (final p in countImages) {
      precacheImage(AssetImage(p), context);
    }
    // 배경/상단/버튼도 프리캐시하면 더 깔끔
    precacheImage(const AssetImage('assets/random_picker/background.png'), context);
    precacheImage(const AssetImage('assets/random_picker/who_is.png'), context);
    precacheImage(const AssetImage('assets/random_picker/skip.png'), context);
  }

  int _getRandomSpacecraftIndex() {
    final random = Random();
    final randomIndex = random.nextInt(widget.selectedIndices.length);
    return widget.selectedIndices[randomIndex];
  }

  void _tickCountdown() {
    if (!mounted) return;
    if (_countdown > 1) {
      setState(() => _countdown--);
    } else {
      _timer.cancel();
      _randomTimer.cancel();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            selectedIndex: _getRandomSpacecraftIndex(),
          ),
        ),
      );
    }
  }

  // 카운트다운
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickCountdown());
  }

  // 12장 이미지 100ms 간격 전환
  void _startSpacecraftImageChanger() {
    _randomTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        _index = (_index + 1) % widget.selectedIndices.length;
      });
    });
  }

  void _skip() {
    _timer.cancel();
    _randomTimer.cancel();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          selectedIndex: _getRandomSpacecraftIndex(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _randomTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 배경
          Positioned.fill(
            child: Image.asset(
              'assets/random_picker/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // 상단 배너
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 735 / 192,
                      child: Image.asset(
                        'assets/random_picker/who_is.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // 본문
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    // 2) IndexedStack: 우주선 이미지(12장) - 위젯 재사용으로 flicker 제거
                    Positioned.fill(
                      child: IndexedStack(
                        index: widget.selectedIndices[_index],
                        alignment: Alignment.center,     // ← 추가
                        sizing: StackFit.expand,         // ← 추가 (자식이 영역을 가득 차게)
                        children: _spacecraftViews,
                      ),
                    ),
                    // 카운트다운 이미지(5장)
                    Positioned(
                      bottom: deviceH / 15 + 20,
                      left: 0,
                      right: 0,
                      height: deviceH / 6,
                      child: IndexedStack(
                        index: _countdown - 1,
                        alignment: Alignment.center,     // ← 추가
                        sizing: StackFit.expand,         // ← 추가
                        children: _countViews,
                      ),
                    ),
                    // skip 버튼
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      height: _isButtonPressed ? deviceH / 17 : deviceH / 15,
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _isButtonPressed = true),
                        onTapUp: (_) => setState(() => _isButtonPressed = false),
                        onTapCancel: () => setState(() => _isButtonPressed = false),
                        onTap: _skip,
                        child: Image.asset(
                          'assets/random_picker/skip.png',
                          fit: BoxFit.contain,
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
