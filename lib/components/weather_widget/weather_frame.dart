//2023-09-02 weather_frame.dart ver2 by han
//openweathermap api를 통한 gps기반 위치로 15시간 내의 기상 정보와 현재 기상정보 확인 및 tts출력(화면 로딩시 / body영역 터치시)
import 'package:blind_support/components/weather_widget/weather_UI.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:blind_support/utility/tts.dart';


const String apiKey = 'abe1ce516ab3e461d4bc81d0b5d0e808';
const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
const String forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

class WeatherFrame extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherFrame> {
  String weatherData = '날씨 정보를 가져오는 중...';
  String currentLocation = '';
  FlutterTts flutterTts = FlutterTts();

  String ttsout = ''; // ttsout을 글로벌 변수로 변경

  @override
  void initState() {
    super.initState();
    checkPermissionAndGetData();
  }

  // 위치 권한을 확인하고, 권한이 있을 경우 데이터를 가져오는 함수
  void checkPermissionAndGetData() async {
    if (await _checkLocationPermission()) {
      getLocationAndWeather();
    } else {
      await _requestLocationPermission();
      if (await _checkLocationPermission()) {
        getLocationAndWeather();
      } else {
        setState(() {
          weatherData = '위치 권한이 필요합니다.';
        });
      }
    }
  }

  // 위치 권한 확인
  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  // 위치 권한 요청
  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
  }

  // 영문 날씨 상태를 한글로 변환하는 함수
  String getKoreanWeatherMain(String englishMain) {
    switch (englishMain) {
      case 'Clear':
        return '맑음';
      case 'Clouds':
        return '구름';
      case 'Rain':
        return '비';
      case 'Snow':
        return '눈';
      case 'Drizzle':
        return '이슬비';
      case 'Thunderstorm':
        return '천둥번개';
      case 'Mist':
        return '안개';
      default:
        return englishMain;
    }
  }

  // 위치 정보를 가져오고 API를 호출하는 함수
  void getLocationAndWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      String currentWeatherUrl =
          '$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
      http.Response currentWeatherResponse =
      await http.get(Uri.parse(currentWeatherUrl));

      String forecastWeatherUrl =
          '$forecastUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
      http.Response forecastWeatherResponse =
      await http.get(Uri.parse(forecastWeatherUrl));

      Map<String, dynamic> currentWeatherMap =
      json.decode(currentWeatherResponse.body);
      Map<String, dynamic> forecastWeatherMap =
      json.decode(forecastWeatherResponse.body);

      String city = currentWeatherMap['name'];
      String currentTemp =
      currentWeatherMap['main']['temp'].toStringAsFixed(1);
      String currentWeatherMain = currentWeatherMap['weather'][0]['main'];
      currentWeatherMain = getKoreanWeatherMain(currentWeatherMain);

      List<dynamic> forecastList = forecastWeatherMap['list'];

      String forecastData = '날씨 예보:\n';
      bool isRainComing = false;
      String rainTime = '';
      DateTime currentTime = DateTime.now();

      for (var forecast in forecastList) {
        String dateString = forecast['dt_txt'];
        DateTime forecastTime = DateTime.parse(dateString);

        // 현재 시간부터 15시간 이내의 예보 데이터만 사용
        if (forecastTime.isAfter(currentTime) &&
            forecastTime.isBefore(currentTime.add(Duration(hours: 15)))) {
          String date = forecast['dt_txt'];
          String temp = forecast['main']['temp'].toStringAsFixed(1);
          String weatherMain = forecast['weather'][0]['main'];
          weatherMain = getKoreanWeatherMain(weatherMain);

          forecastData += '$date - $temp°C, $weatherMain\n';

          if (weatherMain == '비' && rainTime == '') {
            isRainComing = true;
            rainTime = date.substring(11, 16);
            int rainDate = int.parse(date.substring(8, 9));
            int tempRainTime = int.parse(rainTime.substring(0, 1));

            if (tempRainTime < 12) {
              rainTime = '오전 ${rainTime}';
            } else {
              rainTime = '오후 ${tempRainTime - 12}:00';
            }

            if (currentTime.day != rainDate) {
              rainTime = '내일 $rainTime';
            }
          }
        }
      }

      setState(() {
        currentLocation = '현재 위치: $city\n';
        weatherData = '$currentLocation'
            '현재 온도: $currentTemp°C\n'
            '날씨 상태: $currentWeatherMain\n\n'
            '$forecastData';

        if (isRainComing) {
          weatherData += '\n비가 오는 시간은 $rainTime 입니다. '
              '비가 오는 시간이 예상되니 준비하세요!';
          ttsout = '현재 온도는 $currentTemp°C이며, 날씨 상태는 $currentWeatherMain입니다. '
              '비가 오는 시간은 $rainTime 입니다. 비가 오는 시간이 예상되니 준비하세요!';
          TextToSpeechUtil.speakText(ttsout);
        } else {
          weatherData += '\n비 예보가 없습니다.';
          ttsout = '현재 온도는 $currentTemp°C이며, 날씨 상태는 $currentWeatherMain입니다. '
              '비 예보가 없습니다.';
          TextToSpeechUtil.speakText(ttsout);
        }
      });
    } catch (e) {
      setState(() {
        weatherData = '날씨 정보를 가져오지 못했습니다. 오류: $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    try {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('날씨 정보'),
          ),
          body: GestureDetector(
            // 화면을 클릭했을 때 ttsout 내용을 TTS로 재생
              behavior: HitTestBehavior.translucent,
              onTap: () => TextToSpeechUtil.speakText(ttsout),
              child: weatherUI().weatherIconBox(context, weatherData)
          ),
        ),
      );
    } catch(e) {
      print(e);
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('날씨 정보')),
          ),
          body: GestureDetector(
            // 화면을 클릭했을 때 ttsout 내용을 TTS로 재생
              behavior: HitTestBehavior.translucent,
              onTap: () => TextToSpeechUtil.speakText('날씨정보를 불러오는중 입니다.'),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 100, height: 100,
                      child: CircularProgressIndicator(
                        color: Colors.lightGreenAccent,
                        strokeWidth: 10,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text('Loading...', style: TextStyle(
                      fontSize: 20
                    ))
                  ],
                ),
              ),
          ),
        ),
      );
    }
  }
}
