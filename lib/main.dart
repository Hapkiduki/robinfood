import 'package:flutter/material.dart';

import 'package:robinfood/src/pages/home_page.dart';
import 'package:robinfood/src/utils/colors.dart';

import 'package:robinfood/src/utils/fade_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RobinFood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: CustomColors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return FadeRoute(widget: HomePage());
            break;
          default:
            return FadeRoute(widget: HomePage());
        }
      },
    );
  }
}
