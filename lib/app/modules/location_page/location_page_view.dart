import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'location_page_controller.dart';

class LocationPageView extends GetView<LocationPageController> {
  const LocationPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocationPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LocationPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
