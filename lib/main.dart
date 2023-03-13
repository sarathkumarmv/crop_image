import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? imagefile;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop image sample'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90, bottom: 90),
              child: SizedBox(
                child: CircleAvatar(
                    radius: 190,
                    backgroundImage: imagefile == null
                        ? null
                        : FileImage(
                      File(
                        imagefile!.path,
                      ),
                    )),
              ),
            ),
            TextButton(
                onPressed: () async {
                  await imagepick();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.blue),
                  width: double.infinity,
                  height: 45,
                  child: const Center(
                      child: Text(
                        'Add Photo',
                        style: TextStyle(color: Colors.white),
                      )),
                )),
            TextButton(
                onPressed: () async {
                  await cropimage();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.blue),
                  width: double.infinity,
                  height: 45,
                  child: const Center(
                      child: Text(
                        'Crop Photo',
                        style: TextStyle(color: Colors.white),
                      )),
                )),
          ],
        ),
      ),
    );
  }

  Future imagepick() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    } else {
      setState(() {
        imagefile = File(file.path);
      });
    }
  }

  Future cropimage() async {
    if (imagefile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imagefile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          imagefile = File(croppedFile.path);
        });
      }
    } else {
      log('photo null');
    }
  }
}