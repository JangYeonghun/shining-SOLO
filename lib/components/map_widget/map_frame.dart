/*
개발자: 장영훈
2023.07.25 ver.1 네이버 지도 연동하여 화면 띄움(geolocator 최신 안정화 버전 하니까 오류 해결됐음)
2023.07.28 ver.2 구글 지도로 변경하기 위해 네이버 지도 삭제
 */

import 'package:flutter/material.dart';

// MVC 패턴중 Model
class DirectionsFrame extends StatefulWidget {
  @override
  _DirectionsFrameState createState() => _DirectionsFrameState();
}

class _DirectionsFrameState extends State<DirectionsFrame> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('지도 구현 부분'),
    );

  }
}
