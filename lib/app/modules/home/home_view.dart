import 'dart:io';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withValues(alpha: 0.97),
        body: Obx(() {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload a picture',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                SizedBox(height: 20),
                controller.selectedImagePath.value.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 80,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(Assets.icUpload, width: 50),
                              SizedBox(height: 10),
                              Material(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: controller.pickImage,
                                  child: Ink(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Pick an Image",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: kIsWeb
                                  ? controller.imageBytes.value != null
                                        ? Image.memory(
                                            controller.imageBytes.value!,
                                            fit: BoxFit.cover,
                                          )
                                        : Text('No image selected')
                                  : Image.file(
                                      File(controller.selectedImagePath.value),
                                      width: double.infinity,
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                            Positioned(
                              child: IconButton(
                                onPressed: () {
                                  controller.selectedImagePath.value = '';
                                  controller.selectedIndex.value = 0;
                                },
                                icon: Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 40),
                Text(
                  'Select Blend Color',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => showColorPicker(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: controller.selectedColor.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                if (controller.selectedImagePath.value.isNotEmpty) ...[
                  DynamicHeightGridView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.blendModeMap.length,
                    crossAxisCount: kIsWeb?4:2,
                    crossAxisSpacing: kIsWeb? 30:10,
                    mainAxisSpacing: kIsWeb? 30:15,
                    builder: (context, index) {
                      return Obx(() {
                        return InkWell(
                          onTap: () {
                            controller.selectEditedImage(index);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: editedImage(index),
                        );
                      });
                    },
                  ),
                ],
                // editedImage(controller.selectedIndex.value),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget editedImage(int index) {
    bool isSelected = controller.selectedIndex.value == index;
    final entry = controller.blendModeMap.entries.elementAt(index);
    final modeName = entry.key;
    final blendMode = entry.value;
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: kIsWeb
                ? controller.imageBytes.value != null
                      ? Image.memory(
                          controller.imageBytes.value!,
                          fit: BoxFit.contain,
                          color: index == 0
                              ? null
                              : controller.selectedColor.value,
                          colorBlendMode: blendMode,
                        )
                      : Text('No image selected')
                : Image.file(
                    File(controller.selectedImagePath.value),
                    width: double.infinity,
                    fit: BoxFit.contain,
                    color: index == 0 ? null : controller.selectedColor.value,
                    colorBlendMode: blendMode,
                  ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFE1D3F8) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE1D3F8),
                    width: 1,
                  ), // 👈 bottom border here
                ),
              ),

              padding: EdgeInsets.symmetric(vertical: kIsWeb ? 15.0 : 8),
              child: Text(
                modeName.capitalize!,
                style: TextStyle(color: Color(0xFF383838)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: Obx(() {
            return SingleChildScrollView(
              child: ColorPicker(
                pickerColor: controller.selectedColor.value,
                onColorChanged: (color) {
                  controller.selectedColor.value = color;
                },
                enableAlpha: true,
                pickerAreaHeightPercent: 0.9,
              ),
            );
          }),
          actions: [
            TextButton(
              child: Text('Select'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
