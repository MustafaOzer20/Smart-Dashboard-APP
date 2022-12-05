import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smartdashboard/core/models/services.dart';
import 'package:smartdashboard/main.dart';
import 'package:smartdashboard/products/user_model.dart';

class WeatherCreate extends StatefulWidget {
  const WeatherCreate({Key? key}) : super(key: key);
  @override
  State<WeatherCreate> createState() => _WeatherCreateState();
}

class _WeatherCreateState extends State<WeatherCreate> {
  TextEditingController cityController = TextEditingController();
  bool _submit = true;

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
                                  "Service Create",
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
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TextField(
                          controller: cityController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.deepPurple,
                            hintText: "Enter City Name...",
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
                      ElevatedButton(onPressed: submit, child: Text("Submit"))
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
  submit()async{
    if(_submit){
      setState(() {
        _submit = false;
      });
      var weather = await Weather.getWeather(cityController.text);
      if(weather is String){

      }else{
        context.read<User>().addService(weather);
        Get.offAll(MyHomePage());
      }
      setState(() {
        _submit = true;
      });
    }
  }
}
