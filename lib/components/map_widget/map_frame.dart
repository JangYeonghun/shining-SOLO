import 'package:flutter/material.dart';

// MVC 패턴중 Model
class DirectionsFrame extends StatefulWidget {
  @override
  _DirectionsFrameState createState() => _DirectionsFrameState();
}

class _DirectionsFrameState extends State<DirectionsFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // 배경색을 검은색으로 설정
        child: Center(
          child: Text(
            '이곳은 길 찾기 위젯입니다.',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
