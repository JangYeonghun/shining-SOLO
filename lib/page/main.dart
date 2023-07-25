import 'package:flutter/material.dart';
import 'package:blind_support/class/bottom_bar_class.dart';
import 'package:blind_support/components//detecting_widget/detecting_frame.dart';
import 'package:blind_support/components//map_widget/map_frame.dart';
import 'package:blind_support/components//weather_widget/weather_frame.dart';
import 'package:blind_support/utility/tts.dart';


// MVC 패턴 중 View
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedPage = 0; // 현재 선택된 페이지를 나타내는 변수

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DetectingFrame(), // 선택된 페이지에 따라 body를 구성하는 함수 호출
        bottomNavigationBar: BottomBarRoulette(
          onPageSelected: (index) {
            setState(() {
              selectedPage = index; // 페이지가 변경될 때마다 선택된 페이지 업데이트
              print("Selected Page: $selectedPage"); // 콘솔에 선택된 페이지 출력

            });
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (selectedPage) {
      case 0:
      // 홈 화면
        return WeatherFrame();
      case 1:
      // 사물인식 화면
        return DetectingFrame();
      case 2:
      // 길 찾기 화면
        return DirectionsFrame();
      default:
      // 기본적으로 홈 화면을 보여줌
        return WeatherFrame();
    }
  }
}