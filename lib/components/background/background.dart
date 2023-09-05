import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:blind_support/components/gps/gps_stream.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundModule extends StatefulWidget {
  const BackgroundModule({Key? key}) : super(key: key);

  @override
  BackgroundModuleState createState() => BackgroundModuleState();
}

class BackgroundModuleState extends State<BackgroundModule> {

  @override
  void initState() {
    super.initState();

    _initializeService();

    FlutterBackgroundService().on('update_gps').listen((event) {
      setState(() {
        lat = event!['lat'];
        lng = event['lng'];
        accuracy = event['accuracy'];
        heading = event['heading'];
        gpsStatus = event['gpsStatus'];
      });
    });
  }

  Future<void> _initializeService() async {
    final service = FlutterBackgroundService();
    service.invoke(
        'stopService',
        {
        }
    );
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStartBackground,
        autoStart: true,
        isForegroundMode: true,
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStartBackground,
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }

  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}


// Background
@pragma('vm:entry-point')
void onStartBackground(ServiceInstance service) {

  DartPluginRegistrant.ensureInitialized();

  SharedPreferences.getInstance().then((preferences) {
    preferences.setString('hello', 'world');
  });

  onStartGps(service);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // 여기에 원하는 작업을 추가하세요.
      }
    }

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        'device': device,
      },
    );
  });
}