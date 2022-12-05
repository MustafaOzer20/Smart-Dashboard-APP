import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smartdashboard/products/user_model.dart';
import 'package:smartdashboard/main.dart';
import 'package:smartdashboard/core/models/devices.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class DeviceCreate extends StatefulWidget {
  const DeviceCreate({Key? key}) : super(key: key);
  @override
  State<DeviceCreate> createState() => _DeviceCreateState();
}

class _DeviceCreateState extends State<DeviceCreate> {
  Icon? _icon = Icon(
    Icons.devices,
    color: Colors.white,
    size: 50,
  );
  IconData? icon;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  bool status = false;

  _pickIcon() async {
    icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.cupertino]);

    if (icon != null)
      _icon = Icon(
        icon,
        color: Colors.white,
        size: 50,
      );
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
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
                          Get.offAll(MyHomePage());
                        },
                        icon: Icon(Icons.arrow_back_ios_sharp),
                        color: Colors.deepPurple,
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 30),
                            child: Text(
                              "Device Create",
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
                  Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.deepPurpleAccent,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _icon ?? Container(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    onPressed: _pickIcon,
                    child: const Text('Switch Device Icon'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 20,
                  ),

                  /* Device Name Start */
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.deepPurple,
                        hintText: "Enter Device Name...",
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

                  SizedBox(height: 30,),
                  /* Submit Button Start */
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                      onPressed: () {
                        if(valueController.text.isNotEmpty && nameController.text.isNotEmpty){
                          icon ??= Icons.devices;
                          Device device = Device(nameController.text, int.parse(valueController.text), icon!, status, []);
                          context.read<User>().addDevice(device);
                          Get.offAll(MyHomePage());
                        }
                        },
                      child: Text("Submit")
                  ),
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
