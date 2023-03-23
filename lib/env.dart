import 'package:flutter/foundation.dart';

class Env {
  static const String uri = kReleaseMode
      ? "aj-staging.jojo-pets.com"
      : "aj-staging.jojo-pets.com";
}
