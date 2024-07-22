import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int selectedIndex; // RandomPickerScreen으로부터 전달받은 int 파라미터

  ResultScreen({required this.selectedIndex}); // 생성자에서 파라미터를 받음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen'),
      ),
      body: Center(
        child: Text(
          'Selected Index: $selectedIndex', // 전달받은 파라미터를 텍스트로 표시
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}