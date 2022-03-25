import 'package:flutter/material.dart';
import 'package:trello/screens/home_screen/home_screen.dart';



const  _home = '/home';


class ProjectRouter {
  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _home:
        return _buildRoute(settings,  HomeScreen());
    }
    return null;
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget screen) {
    return MaterialPageRoute(settings: settings, builder: (_) => screen);
  }
}


enum Routes {
  home,

}
extension RoutNames on Routes {
  String get path {
    switch (this) {
      case Routes.home:
        return _home;
    }
  }
}