import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechUtil {
  static FlutterTts flutterTts = FlutterTts(); // FlutterTts 인스턴스 생성

  static Future<void> speakText(String text) async {
    await flutterTts.setLanguage("ko-KR"); // 한국어 설정
    await flutterTts.setPitch(1.0); // 음성 톤 설정
    await flutterTts.speak(text); // TTS로 텍스트 읽기
  }
}
