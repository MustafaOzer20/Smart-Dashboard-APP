import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartdashboard/core/models/devices.dart';
import 'package:smartdashboard/core/models/routines.dart';
import 'package:smartdashboard/core/models/services.dart';
import 'package:smartdashboard/products/user_model.dart';
import 'package:smartdashboard/ui/screens/device_create.dart';
import 'package:smartdashboard/ui/screens/device_detail.dart';
import 'package:smartdashboard/ui/screens/weather_create.dart';
import 'package:smartdashboard/ui/widgets/item_card.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_weather_forecast/flutter_weather_forecast.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User user = User();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => user,
        lazy: true,
      ),
    ],
    child: const MyApp(),
  ));
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 30), 0, user.routineWork);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Device> devices = Device.getDatas();
  List<String> navs = ["Devices", "Services"];
  int selectedNav = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: navButtons(),
                ),
                if (selectedNav == 0)
                  for (Widget widget in deviceWidgets()) widget
                else
                  for (Widget widget in serviceWidgets()) widget
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          onPressed: () {
            if(selectedNav == 0)
              Get.offAll(DeviceCreate());
            else
              Get.offAll(WeatherCreate());
          },
          child: selectedNav == 0 ? Text("Add Device") : Text("Add Service")
      ),
    ));
  }

  List<Widget> deviceWidgets() {
    User user = context.read<User>();
    return [
      user.devices.isEmpty
          ? Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height - 150,
              child: Text("No Devices"))
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(
                user.devices.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:
                        DeviceCard(user.devices[index], index),
                  );
                },
              ),
            )
    ];
  }
  List<Widget> serviceWidgets() {
    User user = context.read<User>();
    if(user.services.isEmpty){
      return [Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 150,
          child: Text("No Services"))];
    }
    else{
      List<Widget> widgets = [SizedBox()];
      for(int i=0; i<user.services.length;i++) {
        widgets.add(ListTile(
          onTap: (){
            Alert(
              context: context,
              content: Column(
                children: [
                  Text(user.services[i].city, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 5,),
                  Image.network(user.services[i].iconUrl),
                  Text(user.services[i].condution + " - " + user.services[i].temperature.toString() + " °C", style: TextStyle(fontSize: 16,)),
                  const SizedBox(height: 5,),
                  Text("Humidity: ${user.services[i].humidity.toString()}%", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 5,),
                  Text("Wind: ${user.services[i].wind_kph.toString()} kph", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 5,),
                  Text(user.services[i].last_updated, style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal),)
                ],
              ),
              buttons: [
                DialogButton(
                  child: const Text(
                    "Refresh",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed:(){
                    refresh(user.services[i].city, i);
                  },
                  color: Colors.deepPurpleAccent,
                  radius: BorderRadius.circular(0.0),
                ),
                DialogButton(
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                        deleteService(i);
                        Get.offAll(MyHomePage());
                  },
                  color: Colors.red,
                  radius: BorderRadius.circular(0.0),
                ),
              ]
            ).show();
          },
          leading: Image.network(user.services[i].iconUrl),
          title: Text(user.services[i].city),
          subtitle: Text(user.services[i].last_updated),
          trailing: Text(user.services[i].temperature.toString() + " °C"),

        ));
      }
      return widgets;
    }
  }
  refresh(String city, int index)async{
    var weather = await Weather.getWeather(city);
    if(weather is String){

    }else{
      print(weather.iconUrl);
      context.read<User>().services[index] = weather;
    }
  }
  deleteService(int index){
    context.read<User>().removeService(index);
  }

  List<Widget> navButtons() {
    List<Widget> navs_widget = [];
    for (int index = 0; index < navs.length; index++) {
      if (index == selectedNav) {
        navs_widget.add(navButton(navs[index], true, index));
      } else {
        navs_widget.add(navButton(navs[index], false, index));
      }
      navs_widget.add(SizedBox(
        width: 20,
      ));
    }
    return navs_widget;
  }

  Widget navButton(String name, bool selected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedNav = index;
        });
      },
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
            color: selected ? Colors.deepPurpleAccent : Colors.grey,
            borderRadius: BorderRadius.circular(10)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
