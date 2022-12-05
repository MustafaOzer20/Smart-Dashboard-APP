import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartdashboard/core/models/devices.dart';
import 'package:smartdashboard/core/models/services.dart';

import '../../lib/products/user_model.dart';

void main(){
  test("User Fake Devices", (){
    final user = User();
    expect(user.devices.isEmpty, true);
    user.addFakeDevice();
    expect(user.devices.isEmpty, false);
  });

  test("User Devices CRUD", (){
    final user = User();
    final device = Device("Temperature", 20, Icons.devices, false, []);
    user.addDevice(device);
    expect(user.devices.length, 1);
    expect(user.devices[0].name, "Temperature");
    expect(user.devices[0].status, false);
    user.devices[0].status = true;
    expect(user.devices[0].status, true);
    user.removeDevice(0);
    expect(user.devices.isEmpty, true);
  });

  test("User Services", ()async{
    final user = User();
    final weather = await Weather.getWeather("Zonguldak");
    user.addService(weather);
    expect(user.services.length, 1);
    expect(user.services[0].city, "Zonguldak");
    user.removeService(0);
    expect(user.services.length, 0);
  });

}