import 'dart:collection';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

double lat = 0;
double lng = 0;
double accuracy = 0;
double heading = 0;

String gpsStatus = '';

Queue<Position> gpsQueue = ListQueue<Position>(1);
//double tick = 0;

const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 5
);

// GPS
void onStartGps(ServiceInstance service) {

  Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) async {
    if (position.accuracy >= 30) {
      gpsStatus = '위성 신호 수신이 불안정 합니다.';
      if (gpsQueue.isNotEmpty) {
        position = gpsQueue.removeFirst();
      }
    } else {
      gpsStatus = '위성 신호 수신이 양호합니다.';
    }
    gpsQueue.add(position);

    Position validPosition = position;
    
    lat = validPosition.latitude;
    lng = validPosition.longitude;
    accuracy = validPosition.accuracy;
    heading = validPosition.heading;

    service.invoke(
      'update_gps',
      {
        'lat' : lat,
        'lng' : lng,
        'accuracy' : accuracy,
        'heading' : heading,
        'gpsStatus' : gpsStatus
      },
    );
  });
}