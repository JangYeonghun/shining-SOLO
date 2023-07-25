import 'package:flutter/material.dart';

// MVC 패턴중 Model
class DetectingFrame extends StatefulWidget {
  @override
  _DetectingFrameState createState() => _DetectingFrameState();
}

class _DetectingFrameState extends State<DetectingFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // 배경색을 검은색으로 설정
        child: Center(
          child: Text(
            '이곳은 사물인식 위젯입니다.',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
