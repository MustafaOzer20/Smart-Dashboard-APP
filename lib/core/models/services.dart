import 'dart:convert';

import 'package:http/http.dart' as client;


class Weather{
  String last_updated = "2022-12-03 11:30";
  String city = "Zonguldak";
  double temperature = 10.0;
  String condution = "Partly Cloudy";
  String iconUrl = "//cdn.weatherapi.com/weather/64x64/day/353.png";
  int humidity = 94;
  double wind_kph = 3.6;

  Weather(this.last_updated, this.city, this.temperature, this.condution, this.iconUrl, this.humidity, this.wind_kph);

  static Future<dynamic> getWeather(String city)async{
    String apiKey = "YOUR_API_KEY";
    String apiUri = "http://api.weatherapi.com/v1/current.json?key=${apiKey}&q=${city}&aqi=no";
    var response = json.decode((await client.get(Uri.parse(apiUri))).body);
    if(response["error"] != null){
      return response['error']['message'];
    }
    response = response['current'];
    Weather weather = Weather(
        response['last_updated'],
        city,
        response['temp_c'],
        response['condition']['text'],
        "https:" + response['condition']['icon'],
        response['humidity'],
        response['wind_kph']
    );
    return weather;
  }

}



