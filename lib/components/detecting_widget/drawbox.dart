import 'package:blind_support/const/const.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DrawBox {
  double boxWidth = 0;
  double boxHeight = 0;
  double cameraWidth = 0;
  double cameraHeight = 0;

  DrawBox({required this.boxWidth, required this.boxHeight, required this.cameraWidth, required this.cameraHeight});

  List<Widget> displayBoxesAroundRecognizedObjects(List<Map<String, dynamic>> yoloResults, CameraImage? cameraImage) {
    if (yoloResults.isEmpty || cameraImage == null) {
      return [];
    }

    // double cameraImageWidth = cameraImage.width.toDouble();
    // double cameraImageHeight = cameraImage.height.toDouble();

    // 팩터 계산
    // double factorX = boxWidth / cameraImageHeight;
    // double factorY = boxHeight / cameraImageWidth;

    // double factorX = 1;
    // double factorY = 1;

    double factorX = cameraHeight / boxWidth;
    double factorY = cameraWidth / boxHeight;

    print('나는 boxWidth $boxWidth\n 나는 boxHeight $boxHeight\n 나는 cameraWidth $cameraWidth\n 나는 cameraHeight $cameraHeight\n'
        '나는 factorX $factorX\n 나는 factorY $factorY ');

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    List<Widget> boxes = [];

    for (var result in yoloResults) {
      double left = result["box"][0] * factorX;
      double top = result["box"][1] * factorY;
      double width = (result["box"][2] - result["box"][0]) * factorX;
      double height = (result["box"][3] - result["box"][1]) * factorY;

      print('나는계산한거지롱\n'
          'left: $left\n'
          'top: $top\n'
          'width: $width\n'
          'height: $height');

      boxes.add(
        Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Colors.pink, width: 2.0),
            ),
            child: Text(
              "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()..color = colorPick,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      );
    }

    return boxes;
  }
}
