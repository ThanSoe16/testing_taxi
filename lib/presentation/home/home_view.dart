import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/customs/widgets/testing_button.dart';
import 'package:testing/customs/widgets/testing_dialog.dart';
import 'package:testing/customs/widgets/testing_text.dart';
import 'package:testing/domain/models/location_model.dart';
import 'package:testing/domain/repository/auth_repository.dart';
import 'package:testing/domain/repository/location_repository.dart';
import 'package:testing/utilities/constants.dart';
import 'package:testing/utilities/resources/color_manager.dart';
import 'package:testing/utilities/resources/routes_manager.dart';
import 'package:testing/utilities/resources/styles_manager.dart';
import 'package:testing/utilities/resources/value_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  Position? _position;
  LocationModel locationModel = LocationModel();
  bool isSwitched = false;
  Timer? _timer;
  String text = "Start Background Service";
  String _token = '';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getData();
    super.initState();
  }

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final token = preferences.getString(Constants.prefsToken) ?? '';
    final bgRunning = preferences.getBool(Constants.prefsBGService) ?? false;
    setState(() {
      _token = token;
      text = bgRunning ? 'Stop Background Service' : 'Start Background Service';
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      every30SecBGRun();
    }
  }

  void every30SecBGRun() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    bool bgRunning = preferences.getBool(Constants.prefsBGService) ?? false;
    if (bgRunning) {
      Timer.periodic(const Duration(seconds: 30), (Timer t) async {
        await _apiCallHandler(_token);
      });
    }
  }

  Future<void> _apiCallHandler(String token) async {
    _getCurrentLocation();
    Uri uri = Uri.parse("https://aj-staging.jojo-pets.com/driver/set_location");
    return post(uri,
        headers: {
          'Content-Type': "application/json",
          'access-token': token.toString(),
          'module': 'driver',
          'platform': 'android',
          'client-version': '1.1.10',
          'language': 'en',
          'device-id': 'dev1234567890',
          'operating-system-version': 'lollipop 14.3.2',
          'secure-key': 'EpdM82lwqxphrAFo'
        },
        body: json.encode({
          "latitude": locationModel.latitude ?? 16.858203700000000,
          "longitude": locationModel.longitude ?? 96.121475100000000,
          "source": "background_service"
        })).then((value) {
      if (value.statusCode == 200) {
        print("bg is working");
        print(value.body);
      } else {
        throw Exception('Failed to make API call');
      }
    });
  }

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
      locationModel.latitude = position.latitude;
      locationModel.longitude = position.longitude;
      locationModel.source = "foreground_service";
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void handleLogOut(BuildContext context) {
    Provider.of<AuthRepository>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  void handleSetLocation() async {
    _getCurrentLocation();
    if (locationModel.latitude != null) {
      Provider.of<LocationRepository>(context, listen: false)
          .setLocation(locationModel, _token)
          .then(_onSuccess)
          .catchError(_onError);
    } else {
      showDialog(
          context: context,
          builder: (_) => TestingDialog(
              context: context,
              message: "Plz wait 30 sec to start",
              type: Constants.success));
    }
  }

  void every30Second() async {
    handleSetLocation();
    _timer = Timer.periodic(
        const Duration(seconds: 30), (Timer t) => {handleSetLocation()});
    setState(() {
      isSwitched = false;
    });
  }

  void handleEndLocation() async {
    setState(() {
      isSwitched = true;
      _timer?.cancel();
    });
  }

  void _onSuccess(value) async {
    showDialog(
        context: context,
        builder: (_) => TestingDialog(
            context: context,
            message: "Successful set Location \n $_position",
            type: Constants.success));
  }

  void _onError(value) {
    showDialog(
        context: context,
        builder: (_) => TestingDialog(
            context: context,
            message: value.toString(),
            type: Constants.error));
  }

  void handleBGService(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(Constants.prefsBGService, value) ?? '';
  }

  void toggleSwitch(bool value) {
    handleSwitch(value);
    setState(() {
      isSwitched = value;
    });

  }

  void handleSwitch(bool value){
    if(value){
      every30Second();
    }else{
      handleEndLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _position != null
                  ? TestingText("Current Location: \n$_position",
                      style: getBoldStyle(
                          color: ColorManager.primary, fontSize: 16))
                  : TestingText("No Location Data",
                      style: getBoldStyle(
                          color: ColorManager.primary, fontSize: 14)),
              const SizedBox(
                height: AppSize.s10,
              ),
              const SizedBox(
                height: AppSize.s20,
              ),
              Transform.scale(
                scale: isSwitched ? 3 : 2,
                child: Switch(
                  value: isSwitched,
                  onChanged: toggleSwitch,
                  activeColor: ColorManager.primary,
                  activeTrackColor: ColorManager.primaryOpacity70,
                  inactiveThumbColor: ColorManager.darkGrey,
                  inactiveTrackColor: ColorManager.grey1,
                ),
              ),
              const SizedBox(
                height: AppSize.s20,
              ),

              TestingBtn(
                text: text,
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  var isRunning = await service.isRunning();
                  if (!isRunning) {
                    handleBGService(true);
                    service.startService();
                    service.invoke('setAsBackground');
                  } else {
                    handleBGService(false);
                    service.invoke('stopService');
                  }
                  setState(() {
                    if (!isRunning) {
                      text = 'Stop Background Service';
                    } else {
                      text = 'Start Background Service';
                    }
                  });
                },
                color: ColorManager.primary,
              ),
              const SizedBox(
                height: AppSize.s20,
              ),
              TestingBtn(
                text: "Log Out",
                onPressed: () => {handleLogOut(context)},
                color: ColorManager.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
