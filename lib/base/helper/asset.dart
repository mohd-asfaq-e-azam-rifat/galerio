import 'dart:ui' as ui;

import 'package:flutter/services.dart';

Future<ui.Image> loadImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final fi = await codec.getNextFrame();

  return fi.image;
}
