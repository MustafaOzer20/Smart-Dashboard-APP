import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartdashboard/core/models/routines.dart';


void main(){
  test("Routine instance", (){
    final routine = Routine("Wednesday", "AM", 9, 45, "Turn off the lights", true, 3);
    expect(routine.day, "Wednesday");
    expect(routine.am_pm, "AM");
    expect(routine.hour, 9);
    expect(routine.minute, 45);
    expect(routine.name, "Turn off the lights");
    expect(routine.status, true);
    expect(routine.value, 3);
  });

  test("Routine FakeDatas", (){
    final routines = Routine.getDatas();
    expect(routines.isNotEmpty, true);
    expect(routines.length, 3);
    routines.add(Routine("Wednesday", "AM", 9, 45, "Turn off the lights", true, 3));
    expect(routines.length, 4);
  });


}