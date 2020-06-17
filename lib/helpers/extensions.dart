import 'package:flutter/material.dart';

extension Extra on TimeOfDay {

  String formatted(){
    return '${hour}h${minute.toString().padLeft(2, '0')}';
  }

}