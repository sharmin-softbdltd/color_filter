import 'package:get/get.dart';

import 'location_page_controller.dart';

class LocationPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationPageController>(
      () => LocationPageController(),
    );
  }
}
