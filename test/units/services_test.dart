import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartdashboard/core/models/routines.dart';
import 'package:smartdashboard/core/models/services.dart';


void main(){
  test("Service Weather", ()async{
    final weather = await Weather.getWeather("Zonguldak");
    expect(weather.last_updated is String, true);
    expect(weather.city, "Zonguldak");
    expect(weather.temperature is double, true);
    expect(weather.condution is String, true);
    expect(weather.iconUrl is String, true);
    expect(weather.humidity is int, true);
    expect(weather.wind_kph is double, true);
  });



}