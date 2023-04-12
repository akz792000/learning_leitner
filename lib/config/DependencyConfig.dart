import 'package:get/get.dart';

import '../service/RouteService.dart';

class DependencyConfig {
  static Future registerDependencies() async {
    // register navigation service
    await Get.putAsync<RouteService>(
        () => Future.value(RouteService()));
  }
}
