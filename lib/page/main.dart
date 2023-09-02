/*
개발자: 장영훈
2023.07.25 ver.1 bottom_bar_class 연결, 네이버지도 연결, 메인 페이지 제작, 네이버지도 초기화 추가
2023.07.27 ver.2 detecting_frame 연결, 카메라 초기화 추가
2023.07.28 ver.2 네이버 지도 삭제
 */

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:blind_support/components/bottom_bar_widget/bottom_bar_class.dart';
import 'package:blind_support/components//detecting_widget/detecting_frame.dart';
import 'package:blind_support/components//map_widget/map_frame.dart';
import 'package:blind_support/components//weather_widget/weather_frame.dart';
import 'package:blind_support/utility/tts.dart';

late List<CameraDescription> cameras;
// MVC 패턴 중 View
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 카메라 초기화를 위해 호출
  cameras = await availableCameras();
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
        body: _buildBody(), // 선택된 페이지에 따라 body를 구성하는 함수 호출
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
        return DetectingFrame(cameras: cameras);
      case 2:
      // 길 찾기 화면
      //   return MapFrame();
      default:
      // 기본적으로 홈 화면을 보여줌
        return WeatherFrame();
    }
  }
}