import 'package:flutter/material.dart';
import 'package:business_trip/screens/RandomPickerScreen.dart';

class CharacterChoiceScreen extends StatefulWidget {
  @override
  _CharacterChoiceScreen createState() => _CharacterChoiceScreen();
}

class _CharacterChoiceScreen extends State<CharacterChoiceScreen> {
  final List<String> gridImages = List.generate(12, (index) => 'assets/character_choice/character_${index + 1}.png');
  final List<String> countImages = List.generate(13, (index) => 'assets/character_choice/$index.png');

  List<bool> selectedItems = List.generate(12, (_) => false); // 아이템 선택 상태 저장
  int selectedCount = 0; // 선택된 아이템 수
  bool isButtonPressed = false; // 버튼이 눌렸는지 여부

  // 선택된 아이템 수에 따라 상단 영역의 두 번째 이미지 결정
  String get selectedImage {
    return countImages[selectedCount];
  }

  // 선택된 아이템 수와 버튼 눌림 상태에 따라 하단 영역의 버튼 이미지 결정
  String get bottomButtonImage {
    if (selectedCount > 1) {
      return isButtonPressed ? 'assets/character_choice/button_pushed.png' : 'assets/character_choice/button_available.png';
    } else {
      return 'assets/character_choice/button_unavailable.png';
    }
  }

  void _onGridItemTap(int index) {
    setState(() {
      selectedItems[index] = !selectedItems[index]; // 아이템 선택 상태 토글
      selectedCount = selectedItems.where((selected) => selected).length; // 선택된 아이템 수 카운트
    });
  }

  void _onButtonPressed() {
    setState(() {
      isButtonPressed = true; // 버튼 눌림 상태
    });
  }

  void _onButtonReleased() {
    setState(() {
      isButtonPressed = false; // 버튼 눌림 해제 상태
    });
  }

  void _navigateToRandomPickerScreen() {
    if (selectedCount > 1) {
      List<int> selectedIndices = [];
      for (int i = 0; i < selectedItems.length; i++) {
        if (selectedItems[i]) {
          selectedIndices.add(i);
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RandomPickerScreen(selectedIndices: selectedIndices),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/character_choice/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // 상단 영역
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 516 / 195, // 이미지의 비율에 맞춰 조정 (너비 / 높이)
                        child: Image.asset(
                          'assets/character_choice/candidate.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 365 / 277, // 이미지의 비율에 맞춰 조정 (너비 / 높이)
                        child: Image.asset(
                          selectedImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 중단 영역
              Expanded(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: 915 / 1647, // 이미지의 비율에 맞춰 조정 (너비 / 높이)
                  child: Stack(
                    children: [
                      // 배경 이미지
                      Positioned.fill(
                        child: Image.asset(
                          'assets/character_choice/container.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Padding으로 감싼 그리드뷰
                      Padding(
                        padding: EdgeInsets.all(10.0), // 모든 방향에 10의 패딩 적용
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 열 개수 2개로 설정
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                          ),
                          itemCount: gridImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _onGridItemTap(index), // 아이템 클릭 시 선택 상태 변경
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedItems[index] ? Colors.red : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Image.asset(gridImages[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 하단 영역
              Expanded(
                flex: 1,
                child: Center(
                  child: GestureDetector(
                    onTapDown: (_) => _onButtonPressed(), // 버튼 눌림 상태
                    onTapUp: (_) {
                      _onButtonReleased(); // 버튼 눌림 해제 상태
                      _navigateToRandomPickerScreen(); // 다음 페이지로 이동
                    },
                    onTapCancel: () => _onButtonReleased(), // 버튼 눌림 취소 상태
                    child: AspectRatio(
                      aspectRatio: 477 / 213, // 이미지의 비율에 맞춰 조정 (너비 / 높이)
                      child: Image.asset(
                        bottomButtonImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}