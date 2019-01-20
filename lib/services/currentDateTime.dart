import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class CurrentDateTime{
  DateTime now;
  CurrentDateTime(){
    now=DateTime.now();
  }

  String currentDateTime(){
    now = DateTime.now();
    String formattedDate = DateFormat('K:mm:ss a EEE d MMM yyyy').format(now);
    return formattedDate;
  }
}