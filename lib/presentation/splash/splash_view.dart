import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/customs/widgets/testing_text.dart';
import 'package:testing/domain/repository/auth_repository.dart';
import 'package:testing/utilities/resources/color_manager.dart';
import 'package:testing/utilities/resources/font_manager.dart';
import 'package:testing/utilities/resources/routes_manager.dart';
import 'package:testing/utilities/resources/styles_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    _isAuthenticated();
    super.initState();
  }
  _isAuthenticated() {
    Provider.of<AuthRepository>(context, listen: false).isAuthenticated().then(
            (auth) => Timer(const Duration(seconds: 3),
                () => Navigator.pushReplacementNamed(context, auth ? Routes.homeRoute : Routes.loginRoute)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
        child: Center(
            child: TestingText("Welcome to Taxi",
                style: getBoldStyle(
                    color: ColorManager.primary, fontSize: FontSize.s20))),
      ),
    );
  }
}
