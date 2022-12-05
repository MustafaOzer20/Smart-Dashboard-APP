import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smartdashboard/core/models/devices.dart';
import 'package:smartdashboard/core/models/routines.dart';
import 'package:smartdashboard/main.dart';
import 'package:smartdashboard/products/user_model.dart';
import 'package:smartdashboard/ui/screens/device_detail.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class RoutineCreate extends StatefulWidget {
  const RoutineCreate({Key? key, required this.index, this.routine_index}) : super(key: key);
  final int index;
  final int? routine_index;
  @override
  State<RoutineCreate> createState() => _RoutineCreateState();
}

class _RoutineCreateState extends State<RoutineCreate> {
  TextEditingController valueController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String day = "Monday";
  String am_pm = "AM";
  int hour = 1;
  int minute = 0;
  bool status = false;
  bool edit = false;
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  List<String> am_pm_list = ["AM", "PM"];
  int? startDay = 0;
  int? startPM = 0;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.routine_index != null ){
      Device device = context.read<User>().devices[widget.index];
      Routine routine = device.routines[widget.routine_index!];
      setState(() {
        nameController.text = routine.name;
        valueController.text = routine.value.toString();
        hour = routine.hour;
        minute = routine.minute;
        day = routine.day;
        am_pm = routine.am_pm;
        status = routine.status;
        startDay = days.indexOf(day);
        startPM = am_pm_list.indexOf(am_pm);
        edit = true;
      });
    }

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
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.offAll(DeviceDetailScreen(index: widget.index));
                        },
                        icon: Icon(Icons.arrow_back_ios_sharp),
                        color: Colors.deepPurple,
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 30),
                            child: Text(
                              "Routine Create",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.deepPurpleAccent),
                            )),
                      ),
                      //Text(widget.device.name, style: TextStyle(fontSize: 25),),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  /* Device Name Start */
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurple,
                        hintText: "Enter Routine Name...",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  /* Device Name End */

                  SizedBox(
                    height: 15,
                  ),

                  /* Device Value Start */
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    color: Colors.deepPurple,
                    child: TextFormField(
                      controller: valueController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurple,
                        hintText: "Device Value",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  /* Device Value End */

                  SizedBox(
                    height: 15,
                  ),

                  /* Device Status Checkbox Start */
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    color: Colors.deepPurple,
                    child: ListTile(
                      title: const Text(
                        "Device Status",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Checkbox(
                        activeColor: Colors.green,
                        value: status,
                        onChanged: (value) {
                          setState(() {
                            status = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  /* Device Status Checkbox End */

                  SizedBox(
                    height: 30,
                  ),
                Container(
                  height: 100,
                  width: 120,
                  child: WheelChooser(
                    onValueChanged: (value) {
                      setState(() {
                        day = value;
                      });
                    },
                    startPosition: startDay,
                    datas: days,
                  ),
                ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 120,
                        child: WheelChooser(
                          onValueChanged: (value){
                            setState(() {
                              am_pm = value;
                            });
                          },
                          startPosition: startPM,
                          datas: am_pm_list,
                        ),
                      ),
                      Container(
                          height: 100,
                          width: 120,
                          child: WheelChooser.integer(
                            isInfinite: true,
                            onValueChanged: (value){
                              setState(() {
                                hour = value;
                              });
                            },
                            maxValue: 12,
                            minValue: 1,
                            initValue: hour,
                            unSelectTextStyle: TextStyle(color: Colors.grey),
                          )
                      ),
                      Container(
                          height: 100,
                          width: 120,
                          child: WheelChooser.integer(
                            isInfinite: true,
                            onValueChanged: (value){
                              setState(() {
                                minute = value;
                              });
                            },
                            maxValue: 59,
                            minValue: 0,
                            initValue: minute,
                            unSelectTextStyle: TextStyle(color: Colors.grey),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  /* Submit Button Start */
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent),
                      onPressed: () {

                        if(valueController.text.isNotEmpty && nameController.text.isNotEmpty){
                          int value = int.parse(valueController.text);
                          Routine routine = Routine(day, am_pm, hour, minute, nameController.text, status, value);
                          if(edit){
                            context.read<User>().devices[widget.index].routines[widget.routine_index!] = routine;
                          }else{
                            context.read<User>().devices[widget.index].routines.add(routine);
                          }
                          Get.offAll(DeviceDetailScreen(index: widget.index));
                        }
                        },
                      child: Text("Submit")),
                  /* Submit Button End */
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
