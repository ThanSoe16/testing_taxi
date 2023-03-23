import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:testing/domain/repository/auth_repository.dart';
import 'package:testing/domain/repository/location_repository.dart';

class ApplicationProvider {
  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider.value(
      value: AuthRepository(),
    ),
    ChangeNotifierProvider.value(value: LocationRepository())
  ];
}
