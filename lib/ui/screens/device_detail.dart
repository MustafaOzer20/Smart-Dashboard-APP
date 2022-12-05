import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smartdashboard/main.dart';
import 'package:smartdashboard/core/models/devices.dart';
import 'package:smartdashboard/products/user_model.dart';
import 'package:smartdashboard/ui/screens/routine_create.dart';
import 'package:accordion/accordion.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({super.key, required this.index});
  final int index;
  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  TextEditingController name = TextEditingController();
  Device? device;
  int? index;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      index = widget.index;
      device = context.read<User>().devices[index!];
      name.text = device!.name;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: SafeArea(
          child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.offAll(MyHomePage());
                          },
                          icon: Icon(Icons.arrow_back_ios_sharp)),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 30),
                          child: TextField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.deepPurple,
                              hintText: "Device Name..",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                            controller: name,
                            onChanged: (value) {
                              if (value != "") {
                                setState(() {
                                  //context.watch<User>().setDeviceName(value, index!);
                                  context.read<User>().devices[index!].name =
                                      value;
                                });
                              }
                            },
                            onSubmitted: (value) {
                              if (value != "") {
                                setState(() {
                                  //context.watch<User>().setDeviceName(value, index!);
                                  context.read<User>().devices[index!].name =
                                      value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<User>().removeDevice(widget.index);
                          Get.offAll(MyHomePage());
                        },
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                      //Text(widget.device.name, style: TextStyle(fontSize: 25),),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: SleekCircularSlider(
                        innerWidget: (double value) {
                          return Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                        child: Text("")),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        height: 190,
                                        width: 190,
                                        decoration: BoxDecoration(
                                          color: device!.status
                                              ? Colors.deepPurpleAccent
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                        child: Text("")),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 185,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(185),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context
                                                  .read<User>()
                                                  .devices[index!]
                                                  .status
                                              ? "${value.toInt()} %"
                                              : "${context.read<User>().devices[index!].value} %",
                                          style: TextStyle(
                                              fontSize: 40,
                                              color: device!.status
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                        },
                        appearance: CircularSliderAppearance(
                            animationEnabled: false,
                            size: 300,
                            customWidths: CustomSliderWidths(
                                progressBarWidth: 25,
                                trackWidth: 25,
                                handlerSize: 10,
                                shadowWidth: 35),
                            customColors: !device!.status
                                ? CustomSliderColors(
                                    progressBarColor: Colors.grey,
                                    trackColor: Colors.grey[300])
                                : CustomSliderColors(progressBarColors: [
                                    Color.fromRGBO(51, 0, 51, 1),
                                    Color.fromRGBO(102, 0, 102, 1),
                                    Color.fromRGBO(153, 0, 153, 1)
                                  ])),
                        initialValue: device!.value.toDouble(),
                        onChangeEnd: (double value) {
                          if (context.read<User>().devices[index!].status)
                            context.read<User>().devices[index!].value =
                                value.toInt();
                        },
                        onChange: (double value) {
                          //print(value);
                        }),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent),
                      onPressed: () {
                        setState(() {
                          context.read<User>().devices[index!].status =
                              !context.read<User>().devices[index!].status;
                        });
                        print(device!.status);
                      },
                      child: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      )),
                  context.read<User>().devices[index!].status
                      ? Text("Turn off Device")
                      : Text("Turn on Device"),
                  Accordion(children: [
                    for (int i=0; i< context.read<User>().devices[index!].routines.length;i++)
                      AccordionSection(
                          header: Text(
                            context.read<User>().devices[index!].routines[i].name,
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Column(
                            children: [
                              ListTile(
                                title:
                                    Text("Value: " + context.read<User>().devices[index!].routines[i].value.toString()),
                                subtitle: Text(
                                    "Status: " + context.read<User>().devices[index!].routines[i].status.toString()),
                                trailing: Text(context.read<User>().devices[index!].routines[i].getTimeByString()),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Get.to(RoutineCreate(index: index!, routine_index: i,));
                                      }, child: Text("Edit")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          context.read<User>().devices[index!].routines.removeAt(i);
                                        });
                                      }, child: Text("Delete")),
                                ],
                              )
                            ],
                          )),
                  ]),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () {
              Get.to(RoutineCreate(
                index: widget.index,
              ));
            },
            child: Text("Add Routine")), //Icon(Icons.add)),
      )),
    );
  }
}
