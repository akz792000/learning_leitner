import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_leitner/entity/CardEntity.dart';

import '../enums/CountryEnum.dart';
import '../view/DataView.dart';
import '../view/DownloadView.dart';
import '../view/ErrorView.dart';
import '../view/HomeView.dart';
import '../view/LeitnerView.dart';
import '../view/LevelView.dart';
import '../view/LoadingView.dart';
import '../view/MergeView.dart';
import '../view/PersistView.dart';

class RouteConfig {
  static const String home = "/"; // it should be like this
  static const String error = "/error";
  static const String level = "/level";
  static const String data = "/data";
  static const String leitner = "/leitner";
  static const String persist = "/persist";
  static const String merge = "/merge";
  static const String download = "/download";
  static const String loading = "/loading";

  Route generateRoute(RouteSettings settings) {
    Map? args = settings.arguments != null ? settings.arguments as Map : null;
    switch (settings.name) {
      case home:
        return _buildRoute(const HomeView());
      case level:
        return _buildRoute(LevelView(
          languageEnum: args!["languageEnum"],
        ));
      case data:
        return _buildRoute(DataView(
          languageEnum: args!["languageEnum"],
        ));
      case leitner:
        return _buildRoute(LeitnerView(
          languageEnum: args!["languageEnum"],
          level: args!["level"],
        ));
      case persist:
        return _buildRoute(const PersistView());
      case merge:
        return _buildRoute(MergeView(
          cardEntity: args!["cardEntity"],
        ));
      case download:
        return _buildRoute(const DownloadView());
      case loading:
        return _buildRoute(const LoadingView());
      default:
        return _buildRoute(const ErrorView());
    }
  }

  Route _buildRoute(Widget widget) {
    return PageRouteBuilder(pageBuilder: (ctx, _, __) => widget);
  }
}
