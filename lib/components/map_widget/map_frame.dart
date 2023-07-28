/*
개발자: 장영훈
2023.07.25 ver.1 네이버 지도 연동하여 화면 띄움(geolocator 최신 안정화 버전 하니까 오류 해결됐음)
 */

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

// MVC 패턴중 Model
class DirectionsFrame extends StatefulWidget {
  @override
  _DirectionsFrameState createState() => _DirectionsFrameState();
}

class _DirectionsFrameState extends State<DirectionsFrame> {
  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: const NaverMapViewOptions( // 지도 옵션을 설정할 수 있다
        mapType: NMapType.basic, // 지도 타입
        liteModeEnable: true, // 지도 화질 떨어짐, NMapType 고정, 레이어 그룹 사용 불가, 디스플레이 옵션 변경 불가, 실내 지도 사용 불가, 카메라 줌/회전/틸트시 지도 심벌도 함께 줌/회전/틸트됨, 심벌 터치 이벤트 처리 불가, 마커/심벌 겹침 처리 불가
        // rotationGesturesEnable: false,
        // scrollGesturesEnable: false,
        // tiltGesturesEnable: false,
        // zoomGesturesEnable: false,
        // stopGesturesEnable: false,
        extent: NLatLngBounds(
          southWest: NLatLng(31.43, 122.37),
          northEast: NLatLng(44.35, 132.0),
        ),
      ),
      forceGesture: false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
      onMapReady: (controller) {
        print("네이버 맵 로딩됨!");
      },
      onMapTapped: (point, latLng) {},
      onSymbolTapped: (symbol) {},
      onCameraChange: (position, reason) {},
      onCameraIdle: () {},
      onSelectedIndoorChanged: (indoor) {},

    );
  }
}
