import 'package:flutter/material.dart';
import 'package:smartdashboard/core/models/routines.dart';

class Device{
  String name = "";
  int value = 0;
  IconData icon = Icons.light;
  bool status = false;
  List<Routine> routines = [];

  Device(this.name, this.value, this.icon, this.status, this.routines);

  static List<Device> getDatas(){
    List<Device> devices = [
      Device("Temperature", 25, Icons.device_thermostat_outlined, false, []),
      Device("Lights", 25, Icons.lightbulb_outline, false, []),
      Device("Humidity", 25, Icons.auto_awesome, false, []),
    ];
    return devices;
  }




}