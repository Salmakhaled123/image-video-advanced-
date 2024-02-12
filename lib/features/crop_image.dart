import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CropImage extends StatefulWidget {
  const CropImage({Key? key}) : super(key: key);

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  File? imageFile;
  double angle = 0.0;
  TextEditingController textEditingController = TextEditingController();
  Future pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'edit image',
            toolbarColor: Colors.pink,
            backgroundColor: Colors.purple,
            hideBottomControls: true,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.green,
            cropFrameColor: Colors.amber,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
      });
    }
  }

  void rotateImage() {
    setState(() {
      angle += 90;
      if (angle >= 360) {
        angle = 0;
      }
    });
  }

  Offset position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'edit your image',
      )),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () async {
                  await pickImage();
                },
                child: const Text('pick image')),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await cropImage();
                },
                child: const Text('edit  image')),
            const SizedBox(
              width: 15,
            ),
          ]),
          Expanded(
            child: Container(
              child: imageFile != null
                  ? Transform.rotate(
                      angle: angle,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            position = Offset(position.dx + details.delta.dx,
                                position.dy + details.delta.dy);
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Image.file(imageFile!),
                            ),
                            Transform.translate(
                              offset: position,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SizedBox(
                                  width: 300,
                                  child: TextField(
                                      controller: textEditingController,
                                      cursorColor: Colors.deepOrange,
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                      decoration: const InputDecoration(
                                          hoverColor: Colors.green,
                                          hintText: 'Write something',
                                          hintStyle: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange),
                                          border: InputBorder.none)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                      'No image selected',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    )),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                rotateImage();
              },
              child: const Icon(Icons.rotate_90_degrees_ccw_sharp))
        ],
      ),
    );
  }
}
