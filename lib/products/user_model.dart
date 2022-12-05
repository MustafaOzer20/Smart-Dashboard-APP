import 'package:flutter/material.dart';
import 'package:smartdashboard/core/models/devices.dart';
import 'package:smartdashboard/core/models/services.dart';

class User extends ChangeNotifier{
  List<Device> devices = [];
  List<Weather> services = [];

  void addFakeDevice(){
    if(devices.isEmpty){
      devices = Device.getDatas();
      notifyListeners();
    }
    else{
      List<Device> fakeDevices = Device.getDatas();
      for (var element in fakeDevices) {
        devices.add(element);
      }
      notifyListeners();
    }
  }

  void addDevice(Device device){
    devices.add(device);
    notifyListeners();
  }

  void removeDevice(int index){
    devices.removeAt(index);
    notifyListeners();
  }


  void addService(Weather weather){
    services.add(weather);
    notifyListeners();
  }

  void removeService(int index){
    services.removeAt(index);
    notifyListeners();
  }

  bool compareTimes(int device_idx, int routine_idx){
    bool result = false;
    final time = DateTime.now();
    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    final day = days[time.weekday - 1];
    final hour = time.hour % 12;
    final am_pm = time.hour > 12 ? "PM" : "AM";
    final minute = time.minute;

    try{
      String r_day = devices[device_idx].routines[routine_idx].day;
      String r_am_pm = devices[device_idx].routines[routine_idx].am_pm;
      int r_hour = devices[device_idx].routines[routine_idx].hour;
      int r_minute = devices[device_idx].routines[routine_idx].minute;
      result = (
          (r_day == day) && (r_am_pm == am_pm) &&
              (r_hour == hour) && (r_minute == minute)
      );
    } on RangeError catch(e) {
      return false;
    }


    return result;
  }

  bool routineWork(){
    bool result = false;

    for (int device_idx = 0; device_idx < devices.length; device_idx++) {
      for (int routine_idx = 0; routine_idx < devices[device_idx].routines.length; routine_idx++) {
        result = compareTimes(device_idx, routine_idx);
        if (result) {
          devices[device_idx].value = devices[device_idx].routines[routine_idx].value;
          devices[device_idx].status = devices[device_idx].routines[routine_idx].status;
        }
      }
    }
    return result;
  }





}