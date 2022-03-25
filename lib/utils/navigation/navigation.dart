import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trello/utils/navigation/project_router.dart';


class Navigation {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static dynamic toScreen(
      Routes route, {
        Object? arguments,
      }) async {
    return await navigatorKey.currentState!.pushNamed(
      route.path,
      arguments: arguments,
    );
  }
}