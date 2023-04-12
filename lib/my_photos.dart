import 'package:flutter/material.dart';
import 'package:mycamera/camera.dart';

class MyPhotos extends StatefulWidget {
  const MyPhotos({super.key});

  @override
  State<MyPhotos> createState() => _MyPhotosState();
}

class _MyPhotosState extends State<MyPhotos> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: MyCamera(),
      ),
    );
  }
}
