import 'package:flutter/widgets.dart';

class RouteService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop() {
    navigatorKey.currentState!.pop();
  }

  getCurrentState() {
    return navigatorKey.currentState!;
  }

}
