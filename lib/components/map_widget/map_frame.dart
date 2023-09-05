import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:blind_support/components/gps/gps_stream.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:blind_support/utility/tts.dart';

class MapFrame extends StatefulWidget {
  const MapFrame({Key? key}) : super(key: key);

  @override
  MapFrameState createState() => MapFrameState();
}

class MapFrameState extends State<MapFrame> {
  late GoogleMapController mapController;
  final LatLng _center = LatLng(lat, lng);
  late Timer _rotationTimer;
  bool showAddress = false;
  String currentAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRotationTimer();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getAddress() async {
    try {
      print('$lat\n$lng');
      // 주소 변환을 위한 Kakao API 호출
      final response = await http.get(
        Uri.parse(
            'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$lng&y=$lat'),
        headers: {
          'Authorization': 'KakaoAK 49cc7d7d198d564e9a3843c856353494',
          // 앱 키를 추가하여 인증합니다.
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data != null && data['documents'] != null &&
            data['documents'].length > 0) {
          final address = data['documents'][0]['address']['address_name'];
          currentAddress = '현재 위치: $address';
        } else {
          currentAddress = '주소를 찾을 수 없습니다.';
        }
      } else {
        currentAddress = '주소 변환 실패';
      }
    } catch (e) {
      print('Error: $e');
    }
    TextToSpeechUtil.speakText(currentAddress);
    print("tap!!");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (_center == LatLng(0, 0)) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              } else {
                return Expanded(
                  child: GoogleMap(
                      liteModeEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      trafficEnabled: false,
                      buildingsEnabled: false,
                      indoorViewEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      tiltGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 16.0,
                      ),
                      onTap: (_) {
                        _getAddress();
                      }
                  ),
                );
              }
            }
        ),
      ],
    );
  }

  void _goToMyLocation() {
    final LatLng currentLatLng = LatLng(lat, lng);

    mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLatLng,
            zoom: 17,
            bearing: heading,
          ),
        )
    );
  }

  void _startRotationTimer() {
    _rotationTimer = Timer.periodic(Duration(milliseconds: 1100), (timer) {
      setState(() {
        _goToMyLocation();
      });
    });
  }

  @override
  void dispose() {
    _rotationTimer.cancel();
    super.dispose();
  }
}




