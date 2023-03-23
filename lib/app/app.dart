import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testing/provider.config.dart';
import 'package:testing/utilities/resources/routes_manager.dart';
import 'package:testing/utilities/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  MyApp._internal();

  int appState = 0;
  static final MyApp instance = MyApp._internal();

  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: ApplicationProvider.providers,
        child: Consumer(
          builder: (context, lang, _) => MaterialApp(
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: Routes.splashRoute,
            theme: getApplicationTheme(),
          ),
        ),
      ),
    );
  }
}
