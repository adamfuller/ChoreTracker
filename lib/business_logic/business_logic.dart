library business_logic;

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

part 'services/preferences_svc.dart';


bool isDebug(){
  bool output = false;
  assert(output = true);
  return output;
}