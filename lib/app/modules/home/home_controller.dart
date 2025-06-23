import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final selectedImagePath = ''.obs;
  final imageBytes = Rx<Uint8List?>(null);
  final selectedIndex = 0.obs;
  final selectedColor = Color(0xFFE1D3F8).obs;
  // final selectedColor = (Colors.black).obs;

  final imageMaxWidth = 1024.0;
  final imageMaxHeight = 1920.0;

  final blendModeMap = {
    'darken': BlendMode.darken,
    'lighten': BlendMode.lighten,
    'multiply': BlendMode.multiply,
    'screen': BlendMode.screen,
    'overlay': BlendMode.overlay,
    'color': BlendMode.color,
    'saturation': BlendMode.saturation,
    'luminosity': BlendMode.luminosity,
    'hue': BlendMode.hue,
    'modulate': BlendMode.modulate,
    'hardLight': BlendMode.hardLight,
    'colorBurn': BlendMode.colorBurn,
    'difference': BlendMode.difference,
    'colorDodge': BlendMode.colorDodge,
    'exclusion': BlendMode.exclusion,
    'softLight': BlendMode.softLight,
    'dst': BlendMode.dst,
    'dstIn': BlendMode.dstIn,
    'dstOut': BlendMode.dstOut,
    'dstOver': BlendMode.dstOver,
    'plus': BlendMode.plus,
    'src': BlendMode.src,
    'srcIn': BlendMode.srcIn,
    'srcOut': BlendMode.srcOut,
    'srcOver': BlendMode.srcOver,
    'clear': BlendMode.clear,
  };

  @override
  void onInit() {
    super.onInit();
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: imageMaxWidth,
      maxHeight: imageMaxHeight,
      imageQuality: 80,
    );
    imageBytes.value = await pickedImage?.readAsBytes();
    if (pickedImage != null) {
      selectedImagePath.value = pickedImage.path.toString();
    }
  }

  selectEditedImage(int index) {
    selectedIndex.value = index;
  }
}
