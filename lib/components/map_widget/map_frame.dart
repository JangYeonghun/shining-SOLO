//2023-07-28 map_frame.dart ver1 by han
//KaKaoMap api를 통한 위치 확인 및 tts 안내
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:blind_support/utility/tts.dart';
// import 'package:provider/provider.dart';

class MessageData extends ChangeNotifier {
  String _message = '';

  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }
}
//
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => MessageData(),
//       child: MaterialApp(
//         title: 'Location',
//         home: MapFrame(),
//       ),
//     ),
//   );
// }
//
// class MapFrame extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     AuthRepository.initialize(appKey: '	15a4f24f725fd737f13ccd2156f12dad');
//     return MaterialApp(
//       title: 'Location',
//       home: ChangeNotifierProvider(
//         create: (context) => MessageData(), // MessageData 제공
//         child: GpsScreen(title: 'Gps Location Update'),
//       ),
//     );
//   }
// }
//
// class GpsScreen extends StatefulWidget {
//   const GpsScreen({Key? key, this.title}) : super(key: key);
//
//   final String? title;
//
//   @override
//   State<GpsScreen> createState() => _GpsScreenState();
// }
//
// class _GpsScreenState extends State<GpsScreen> {
//   KakaoMapController? mapController;
//   FlutterTts flutterTts = FlutterTts();
//   bool move = false;
//
//   StreamSubscription<Position>? _positionStreamSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     requestLocationPermission(); // 위치 권한 요청 추가
//   }
//
//   @override
//   void dispose() {
//     _positionStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//   void requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // 사용자가 위치 권한을 거부한 경우 처리할 코드를 추가하세요.
//     } else if (permission == LocationPermission.deniedForever) {
//       // 사용자가 영구적으로 위치 권한을 거부한 경우 처리할 코드를 추가하세요.
//     } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
//       // 위치 권한을 얻은 경우, 실시간 위치 추적 시작
//       _startListeningToLocationUpdates();
//     }
//   }
//
//   void _startListeningToLocationUpdates() {
//     // 위치 업데이트를 구독하고, 실시간 위치 추적 시작
//     _positionStreamSubscription = Geolocator.getPositionStream().listen(
//           (Position position) {
//         // 위치 업데이트가 발생할 때마다 호출되는 콜백 함수
//         _updateMapAndMessage(position);
//       },
//     );
//   }
//
//   void _updateMapAndMessage(Position position) async {
//     try {
//       mapController?.panTo(LatLng(position.latitude, position.longitude));
//
//       // 주소 변환을 위한 Kakao API 호출
//       final response = await http.get(
//         Uri.parse(
//             'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=${position.longitude}&y=${position.latitude}'),
//         headers: {
//           'Authorization': 'KakaoAK 49cc7d7d198d564e9a3843c856353494', // 앱 키를 추가하여 인증합니다.
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data != null && data['documents'] != null && data['documents'].length > 0) {
//           final address = data['documents'][0]['address']['address_name'];
//
//           // Provider를 사용하여 메시지를 업데이트합니다.
//           Provider.of<MessageData>(context, listen: false).updateMessage('현재 위치: $address');
//         } else {
//           // Provider를 사용하여 메시지를 업데이트합니다.
//           Provider.of<MessageData>(context, listen: false).updateMessage('주소를 찾을 수 없습니다.');
//         }
//       } else {
//         // Provider를 사용하여 메시지를 업데이트합니다.
//         Provider.of<MessageData>(context, listen: false).updateMessage('주소 변환 실패');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? '현재 위치'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: KakaoMap(
//               onMapCreated: ((controller) {
//                 mapController = controller;
//                 controller.setDraggable(move);
//                 controller.setZoomable(move);
//               }),
//               center: LatLng(35.169, 129.056),
//               onMapTap: ((latLng) {
//                 TextToSpeechUtil.speakText(Provider.of<MessageData>(context, listen: false).message);
//               }),
//             ),
//           ),
//           // Use Consumer to wrap the new MessageTextWidget
//           Consumer<MessageData>(
//             builder: (context, messageData, _) {
//               return MessageTextWidget(messageData.message);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // 추가된 MessageTextWidget
// class MessageTextWidget extends StatelessWidget {
//   final String message;
//
//   MessageTextWidget(this.message);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         message,
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
