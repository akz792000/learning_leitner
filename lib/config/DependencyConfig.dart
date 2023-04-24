import 'package:get/get.dart';

import '../repository/CardRepository.dart';
import '../service/RouteService.dart';

class DependencyConfig {
  static Future registerDependencies() async {
    await Get.putAsync<RouteService>(() => Future.value(RouteService()));
    await Get.putAsync<CardRepository>(() => Future.value(CardRepository()));
  }
}
