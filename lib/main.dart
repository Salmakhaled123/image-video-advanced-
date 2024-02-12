import 'package:flutter/material.dart';
import 'package:image_video_topics/features/crop_image.dart';
import 'package:image_video_topics/features/play_video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: PlayVideo(),
    );
  }
}
