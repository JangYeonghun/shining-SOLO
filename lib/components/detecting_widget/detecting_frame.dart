/*
개발자: 장영훈
2023.07.27 ver.1 카메라에 YOLOv8을 변환한 tflite 파일 구동 성공
2023.07.28 ver.2 카메라 위젯 크기와 boundingbox 위치 맞춤
+ 객체 소실시 boundingbox도 소실
+음성추가
+단계추가
 */

import 'package:blind_support/components/detecting_widget/drawbox.dart';
import 'package:blind_support/const/const.dart';
import 'package:flutter/material.dart';
import 'dart:collection'; // 큐를 사용하기 위한 라이브러리
import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';

class DetectingFrame extends StatefulWidget {
  final List<CameraDescription> cameras; // cameras 변수를 매개변수로 추가

  DetectingFrame({Key? key, required this.cameras}) : super(key: key);

  @override
  _DetectingFrameState createState() => _DetectingFrameState();
}

class _DetectingFrameState extends State<DetectingFrame> {
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  Queue<List<Map<String, dynamic>>> resultQueue = Queue();
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double boxWidth = 0;
  double boxHeight = 0;
  double cameraWidth = 0;
  double cameraHeight = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((value) {
      final currentResolution = controller.value.previewSize;
      cameraWidth = currentResolution!.width;
      cameraHeight = currentResolution!.height;
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
          startDetection(); // Start the detection immediately after initialization
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }


  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.value.isInitialized && !controller.value.isStreamingImages) {
      // 카메라가 초기화되었고 이미지 스트리밍이 시작되지 않았다면
      startDetection(); // 카메라 스트리밍 시작
    }

    const bottomNavigationBarHeight = kBottomNavigationBarHeight; // 하단바 높이 가져오기
    print('아아아아아아아아아$bottomNavigationBarHeight');

    // 카메라 위젯의 크기를 GlobalKey를 통해 얻어옵니다.
    final cameraWidgetSize = (context.findRenderObject() as RenderBox).size;
    boxWidth = ScreenSizeHelper.getDisplayWidth(context) * ScreenSizeHelper.getDevicePixelRatio(context);
    boxHeight = ScreenSizeHelper.getDisplayHeight(context) * ScreenSizeHelper.getDevicePixelRatio(context);

    return Scaffold(
      appBar: AppBar(title: Text('Object Detection')),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: bottomNavigationBarHeight,
            left: 0,
            right: 0,
            child: CameraPreview(controller),
          ),
          ...DrawBox(boxWidth: boxWidth, boxHeight: boxHeight, cameraWidth: cameraWidth, cameraHeight: cameraHeight).displayBoxesAroundRecognizedObjects(yoloResults, cameraImage),

          // ...displayBoxesAroundRecognizedObjects(
          //   Size(
          //     MediaQuery.of(context).size.width,
          //     MediaQuery.of(context).size.height - bottomNavigationBarHeight, // 하단바 높이만큼 빼서 표시
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labelstest.txt',
      modelPath: 'assets/test16.tflite',
      modelVersion: "yolov8",
      numThreads: 2,
      useGpu: true,
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    // 결과를 큐에 추가합니다.
    resultQueue.add(result);

    // 큐의 크기를 최대 3으로 제한합니다.
    if (resultQueue.length > 6) {
      resultQueue.removeFirst();
    }

    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    } else if (resultQueue.every((result) => result.isEmpty)) {
      setState(() {
        yoloResults.clear();
      });    }
    print('나는 isNotEmpty11-11$yoloResults');
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }


}