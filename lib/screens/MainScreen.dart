import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 버튼 클릭 시 할 동작을 여기에 정의
          },
          child: Text('Click Me!'),
        ),
      ),
    );
  }
}