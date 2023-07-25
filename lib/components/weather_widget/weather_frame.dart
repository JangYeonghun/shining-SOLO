import 'package:flutter/material.dart';

// MVC 패턴중 Model
class WeatherFrame extends StatefulWidget {
  @override
  _WeatherFrameState createState() => _WeatherFrameState();
}

class _WeatherFrameState extends State<WeatherFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // 배경색을 검은색으로 설정
        child: Center(
          child: Text(
            '이곳은 날씨 위젯입니다.',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
