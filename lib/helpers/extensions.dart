import 'package:flutter/material.dart';

extension Extra on TimeOfDay {

  String formatted(){
    return '${hour}h${minute.toString().padLeft(2, '0')}';
  }

  int toMinutes() => hour*60 + minute;

}