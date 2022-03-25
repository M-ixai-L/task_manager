import 'package:flutter/material.dart';
import 'package:trello/screens/home_screen/home_screen.dart';
import 'package:trello/utils/navigation/navigation.dart';
import 'package:trello/utils/navigation/project_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: Navigation.navigatorKey,
      initialRoute: Routes.home.path,
      onGenerateRoute: ProjectRouter.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}



