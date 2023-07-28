/*
개발자: 장영훈
2023.07.25 ver.1 하단바 스와이프 형식으로 선택할 수 있고 한번 클릭시 해당 기능을 읽어주고, 더블 클릭시 onPageSelected에 값을 전달해 main.dart에서 body를 바꿀 수 있게 함
2023.07.28 ver.2 하단바를 한번 클릭시 해당 기능을 실행하도록 바꿈
 */

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:blind_support/utility/tts.dart';

class BottomBarRoulette extends StatefulWidget {
  final ValueChanged<int> onPageSelected; // 커스텀 콜백

  BottomBarRoulette({required this.onPageSelected});

  @override
  _BottomBarRouletteState createState() => _BottomBarRouletteState();
}

class _BottomBarRouletteState extends State<BottomBarRoulette> {
  int _selectedIndex = 0;
  final List<String> _items = ['홈', '사물인식', '길 찾기'];

  FlutterTts flutterTts = FlutterTts(); // FlutterTts 인스턴스 생성

  bool _isFirstTap = true; // 첫 번째 누름 여부를 나타내는 변수

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: CarouselSlider(
        items: _items.map((item) => _buildCarouselItem(item)).toList(),
        options: CarouselOptions(
          height: 100,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) async {
            setState(() {
              _selectedIndex = index;
              _isFirstTap = true; // 페이지가 변경될 때 마다 첫 번째 누름으로 초기화
            });
            TextToSpeechUtil.speakText(
                _items[index]); // 페이지가 변경될 때 해당 기능 읽어주기

            await flutterTts.stop(); // TTS 인스턴스 닫기
          },
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String item) {
    return GestureDetector(
      onTap: () {
        _handleTap(item);
      },
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            item,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(String item) async {
    // 누름에 따라 TTS 실행
    TextToSpeechUtil.speakText("$item 버튼 실행");
    await flutterTts.stop();

    // 해당 기능이 실행되도록 구현
    switch (_selectedIndex) {
      case 0:
      // 홈 항목 선택 시 동작
        widget.onPageSelected(0); // 해당 페이지 선택 (0은 홈 화면)
        break;
      case 1:
      // 사물인식 항목 선택 시 동작
        widget.onPageSelected(1); // 해당 페이지 선택 (1은 사물인식 화면)
        break;
      case 2:
      // 길 찾기 항목 선택 시 동작
        widget.onPageSelected(2); // 해당 페이지 선택 (2는 길 찾기 화면)
        break;
    }
    // _isFirstTap = true; // 기능 실행 후에는 다시 첫 번째 누름을 기다리도록 설정
  }
}
