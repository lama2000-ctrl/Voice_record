import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_record/graph/graph_view.dart';
import 'package:voice_record/home_page.dart';
import 'package:voice_record/splash_screen.dart';
import 'package:voice_record/views/record_view.dart';

class RouteHelper {
  static const String initial = "/";
  static const String recordView = "/Record-View";
  static const String graphView = "/Graph-View";
  static const String splahScreen = '/splash-page';

  static String getSplashPage() => '/$splahScreen';
  static String getInitial() => '$initial';
  static String getRecordView() => '$recordView';
  static String getGraphView() => '$graphView';
  static List<GetPage> routes = [
    GetPage(name: initial, page: () => HomePage(), transition: Transition.fade),
    GetPage(
        name: "/splash-page",
        page: () {
          return SplashScreen();
        }),
    GetPage(
        name: "/Record-View",
        page: () {
          return RecordView();
        }),
    GetPage(
        name: "/Graph-View",
        page: () {
          return GraphView();
        }),
  ];
}
