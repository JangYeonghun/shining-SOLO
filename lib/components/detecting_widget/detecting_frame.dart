/*
개발자: 장영훈
2023.07.27 ver.1 카메라에 YOLOv8을 변환한 tflite 파일 구동 성공
2023.07.28 ver.2 카메라 위젯 크기와 boundingbox 위치 맞춤
+ 객체 소실시 boundingbox도 소실
+음성추가
+단계추가
 */

import 'package:flutter/material.dart';
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
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((value) {
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

    final bottomNavigationBarHeight = kBottomNavigationBarHeight; // 하단바 높이 가져오기

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
          ...displayBoxesAroundRecognizedObjects(MediaQuery.of(context).size),

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
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
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

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    // final bottomNavigationBarHeight = kBottomNavigationBarHeight; // 하단바 높이 가져오기
    // if (yoloResults.isEmpty) return [];
    // double factorX = screen.width / (cameraImage?.height ?? 1);
    // double factorY = screen.height / (cameraImage?.width ?? 1);
    if (yoloResults.isEmpty || cameraImage == null) {
      return [];

    }

    double cameraImageWidth = cameraImage!.width.toDouble();
    double cameraImageHeight = cameraImage!.height.toDouble();

    // 난 이게 왜 가능한지 모르겠다 씹 쨋든 된다 나중에 좀더 수정해 보자
    // 이건 그냥 던져봤는데 된거고
    // 사실 bottomNavigationBarHeight 이거를 height에 더하려고 했었다
    // 지금은 시간이 없으니 나중에 해보자
    double factorX = screen.width / cameraImageWidth;
    double factorY = screen.width / cameraImageHeight;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
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
      );
    }).toList();
  }
}
