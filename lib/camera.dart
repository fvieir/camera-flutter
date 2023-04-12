import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MyCamera extends StatefulWidget {
  const MyCamera({super.key});

  @override
  State<MyCamera> createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> {
  List<CameraDescription> _cameras = [];
  CameraController? controller;
  XFile? image;
  Size? size;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  Future<void> _loadCameras() async {
    try {
      _cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {
      print(e.code);
      print(e.description);
      error = e.code;
    }
  }

  _loadCamerasT() {
    // error = '';
    print(controller!.value);
    print(_cameras);
    print(mounted);

    _cameras = [];
  }

  _startCamera() {
    if (_cameras.isEmpty) {
      print('Camera não foi encontrada');
    } else {
      print('entrou');
      _previewCamera(_cameras.first);
    }
  }

  _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e.description);
      print(e.code);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: _arquivoWidget(),
      ),
    );
  }

  _arquivoWidget() {
    return SizedBox(
      width: size!.width,
      height: size!.height - (size!.height / 3),
      child: image == null
          ? _cameraPreviewWidget()
          : Image.file(File(image!.path)),
    );
  }

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Widget para Câmera que não está disponíve',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CameraPreview(controller!),
          _botaoCaputaWidget(),
        ],
      );
    }
  }

  _botaoCaputaWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.black.withOpacity(0.5),
        child: IconButton(
          icon: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30,
          ),
          onPressed: tiraFoto,
        ),
      ),
    );
  }

  tiraFoto() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();
        if (mounted) setState(() => image = file);
        print(image!.name);
        print(image!.path);
      } on CameraException catch (e) {
        debugPrint(e.description);
      }
    }
  }
}
