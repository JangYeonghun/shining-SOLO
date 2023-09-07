import 'package:flutter_tts/flutter_tts.dart';

class SpeakDetected {
  final FlutterTts flutterTts = FlutterTts();
  String text = "전방에";

  Future<void> speakDetectedObjects(List<Map<String, dynamic>> result) async {
    print('이건 리절트$result');
    if (result.isNotEmpty) {
      for (var object in result) {
        String label = object["tag"];
        text += "$label 입니다";
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(text);
      }
    }
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }
}
