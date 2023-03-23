import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/app/app.dart';
import 'package:testing/utilities/constants.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _getCurrentLocation();
  await initializeService();
  runApp(MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        bgServiceHandler();
      }
    }

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device
      },
    );
  });
}

void bgServiceHandler() async {
  print("bgRunning");
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  bool bgRunning = preferences.getBool(Constants.prefsBGService) ?? false;
  if (bgRunning) {
    print("bgRunningCorrect");
    final token = preferences.getString(Constants.prefsToken) ?? '';
    if (token != '') {
      await _apiCallHandler(token);
    } else {
      print("token is missing");
    }
  }
}

Future<Position> _getCurrentLocation() async {
  Position position = await _determinePosition();
  return position;
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

Future<void> _apiCallHandler(String token) async {
  Position p = await _getCurrentLocation();
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
        "latitude": p.latitude ?? 16.858203700000000,
        "longitude": p.longitude ?? 96.121475100000000,
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
