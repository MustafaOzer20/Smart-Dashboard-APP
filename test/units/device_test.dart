import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartdashboard/core/models/devices.dart';
import 'package:smartdashboard/core/models/routines.dart';
import 'package:smartdashboard/products/user_model.dart';



void main(){
  test("Device instance", (){
    final device = Device("Test Device", 25, Icons.add, false, []);
    expect(device.name, "Test Device");
    expect(device.value, 25);
    expect(device.icon, Icons.add);
    expect(device.status, false);
    expect(device.routines.isEmpty, true);
  });

  test("Device getDatas", (){
    final devices = Device.getDatas();
    final device = Device("Test Device", 25, Icons.add, false, []);
    expect(devices is List<Device>, true);
    expect(devices.isNotEmpty, true);
    expect(devices.length, 3);
    devices.add(device);
    expect(devices.length, 4);
  });

  test("Device Routines", (){
    final device = Device("Test Device", 25, Icons.add, false, []);
    final routine = Routine("Wednesday", "AM", 9, 45, "Turn off the lights", true, 3);
    expect(device.routines.isEmpty, true);
    device.routines.add(routine);
    expect(device.routines.isNotEmpty, true);
    expect(device.routines[0].status, true);
    expect(device.routines[0].value, 3);
  });

  test("Device Routine Work", (){
    final user = User();
    final routines = Routine.getDatas();
    user.devices = Device.getDatas();

    for(int index=0; index < user.devices.length; index++){
      user.devices[index].routines = routines;
    }

    bool result = user.compareTimes(user.devices.length-1, routines.length-1);
    expect(user.routineWork(), result);

  });
}