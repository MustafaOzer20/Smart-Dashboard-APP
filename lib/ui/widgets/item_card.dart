import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartdashboard/core/models/services.dart';
import 'package:smartdashboard/ui/screens/device_detail.dart';
import 'package:smartdashboard/core/models/devices.dart';


Widget DeviceCard(Device device, int index){
  return GestureDetector(
    onTap: (){
      Get.offAll(DeviceDetailScreen(index:index));
    },
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurpleAccent
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Align(alignment: Alignment.topCenter, child: Icon(device.icon, color: Colors.white, size: 120,) ,),
            Align(alignment: Alignment.bottomCenter,child: Text(device.name, style: TextStyle(color: Colors.white),),)
          ],
        ),
      ),
    ),
  );
}

Widget ServiceCard(Weather weather, int index){
  return GestureDetector(
    onTap: (){
      Get.offAll(DeviceDetailScreen(index:index));
    },
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurpleAccent
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Align(alignment: Alignment.topCenter, child: Image.network(weather.iconUrl) ,),
            Align(alignment: Alignment.bottomCenter,child: Text(weather.city, style: TextStyle(color: Colors.white),),)
          ],
        ),
      ),
    ),
  );
}