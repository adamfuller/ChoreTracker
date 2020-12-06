import 'package:chore_helper/app/app.dart';
import 'package:chore_helper/business_logic/business_logic.dart';
import 'package:flutter/material.dart';

void main() async {
  Future.delayed(Duration(milliseconds: 50), (){
    PreferencesSvc.init();
  });
  runApp(MainView());
}

