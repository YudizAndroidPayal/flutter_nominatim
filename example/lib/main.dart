import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_nominatim_example/nominatim_page.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: NominatimPage()));
}
