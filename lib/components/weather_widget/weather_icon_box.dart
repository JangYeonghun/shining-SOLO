import 'package:flutter/material.dart';

class weatherUI {

  double boxWidth = 0;
  double boxHeight = 0;

  String weatherToIcon(String weather) {
    String iconRoute = '';
    if (weather == '맑음') {
      iconRoute = 'assets/img/sun.png';
    } else if (weather == '구름') {
      iconRoute = 'assets/img/clouds.png';
    } else if (weather == '비') {
      iconRoute = 'assets/img/rain.png';
    } else if (weather == '눈') {
      iconRoute = 'assets/img/snow.png';
    } else if (weather == '이슬비') {
      iconRoute = 'assets/img/rain.png';
    } else if (weather == '천둥번개') {
      iconRoute = 'assets/img/thunder.png';
    } else if (weather == '안개') {
      iconRoute = 'assets/img/mist.png';
    }
    return iconRoute;
  }

  Widget weatherIconBox(BuildContext context, String weatherData) {
    boxWidth = MediaQuery.of(context).size.width / 5.2;
    boxHeight = MediaQuery.of(context).size.height / 5.2;

    final List<String> lines = weatherData.split('\n');

    final String currentWeather = lines[2].substring(7);
    final String currentLocal = lines[0].substring(6);
    final String currentTemperature = lines[1].substring(6);

    final String weather1 = lines[5].substring(30);
    final String temperature1 = lines[5].substring(21, 27);
    final String time1 = lines[5].substring(11, 16);
    final String date1 = lines[5].substring(5, 10);

    final String weather2 = lines[6].substring(30);
    final String temperature2 = lines[6].substring(21, 27);
    final String time2 = lines[6].substring(11, 16);
    final String date2 = lines[6].substring(5, 10);

    final String weather3 = lines[7].substring(30);
    final String temperature3 = lines[7].substring(21, 27);
    final String time3 = lines[7].substring(11, 16);
    final String date3 = lines[7].substring(5, 10);

    final String weather4 = lines[8].substring(30);
    final String temperature4 = lines[8].substring(21, 27);
    final String time4 = lines[8].substring(11, 16);
    final String date4 = lines[8].substring(5, 10);

    final String weather5 = lines[9].substring(30);
    final String temperature5 = lines[9].substring(21, 27);
    final String time5 = lines[9].substring(11, 16);
    final String date5 = lines[9].substring(5, 10);

    final String umbrella = lines[11];


    return Container(color: Color(0xDFDFDFFF),
      child: Padding(
        padding: EdgeInsets.all(boxWidth * 0.1),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(50, 0, 0, 0),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                    offset: Offset(1, 5)
                  )
                ]
              ),
              child: Padding(
                  padding: EdgeInsets.all(boxWidth * 0.05),
                  child: Column(
                    children: [
                      Container(width: boxWidth*5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: boxWidth*3.2, height: boxHeight*1.5,
                                child: Image.asset(weatherToIcon(currentWeather))),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(currentLocal, style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                                )),
                                Text(currentTemperature, style: TextStyle(
                                  fontSize: 20
                                ))
                              ]
                            )
                          ]
                        ),
                      )
                    ]
                  )
              )
            ),
            SizedBox(height: boxHeight*0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                futureWeather(weather1, temperature1, time1, date1),
                futureWeather(weather2, temperature2, time2, date2),
                futureWeather(weather3, temperature3, time3, date3),
                futureWeather(weather4, temperature4, time4, date4),
                futureWeather(weather5, temperature5, time5, date5)
              ]
            ),
            SizedBox(height: boxHeight*0.03),
            rainOrNot(umbrella)
          ]
        )
      ),
    );
  }

  Widget futureWeather(String weather, String temperature, String time, String date) {
    return Container(height: boxHeight*0.85,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(50, 0, 0, 0),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1, 5)
          )
        ]
      ),
      child: Padding(
          padding: EdgeInsets.all(boxWidth * 0.07),
          child: Column(
            children: [
              SizedBox(width: 60, height: 60,
                  child: Image.asset(weatherToIcon(weather))),
              Text(temperature, style: TextStyle(
                  fontSize: 16,
              )),
              Text('${date.substring(0, 2)}월 ${date.substring(3, 5)}일', style: TextStyle(
                fontSize: 14
              )),
              Text(time, style: TextStyle(
                fontSize: 18,
              ))
            ]
          ),
      )
    );
  }

  Widget rainOrNot(umbrella) {
    bool shiny = false;
    String rainTime = '';
    if (umbrella.substring(0, 9) == '비가 오는 시간은') {
      shiny = false;
    } else {
      shiny =true;
    }
    
    if (umbrella.substring(10, 12) == "내일") {
      rainTime = umbrella.substring(10,21);
    } else {
      rainTime = '오늘 ${umbrella.substring(10,18)}';
    }

    return shiny ? noRain() : Container(height: boxHeight*1.1, width: boxWidth*5,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(50, 0, 0, 0),
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                  offset: Offset(1, 5)
              )
            ]
        ),
        child: Padding(
            padding: EdgeInsets.all(boxWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(boxWidth * 0.15),
                  child: Image.asset('assets/img/umbrella.png'),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('우산을 챙기세요\n', style: TextStyle(
                        fontSize: 20
                      ),),
                      Text(rainTime.substring(0, 6), style: TextStyle(
                        fontSize: 20
                      ),),
                      Text(rainTime.substring(6), style: TextStyle(
                        fontSize: 35
                      ),)
                    ]
                ),
              ],
            )
        )
    );
  }

  Widget noRain() {
    return Container(height: boxHeight*1.1, width: boxWidth*5,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(50, 0, 0, 0),
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                  offset: Offset(1, 5)
              )
            ]
        ),
        child: Padding(
            padding: EdgeInsets.all(boxWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(boxWidth*0.15),
                  child: Image.asset('assets/img/flower.png'),
                ),
                Text('비 예보가 없어요', style: TextStyle(
                  fontSize: 20
                ))
              ]
            )
        )
    );
  }
}
