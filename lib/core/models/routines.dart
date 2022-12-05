class Routine{
  String day = "Monday";
  String am_pm = "AM";
  int hour = 1;
  int minute = 0;
  String name = "";
  bool status = false;
  int value = 0;

  Routine(this.day, this.am_pm, this.hour, this.minute, this.name, this.status, this.value);

  static List<Routine> getDatas(){
    DateTime time = DateTime.now();
    List<Routine> routines = [
      Routine("Monday", "PM", 10, 50, "Routine 1", true, 10),
      Routine("Thursday", "AM", 8, 25, "Routine 2", false, 0),
      Routine("Sunday", "PM", 3, 40, "Routine 3", true, 5),
    ];
    return routines;
  }

  String getTimeByString(){
    return "${day} ${hour}:${minute} ${am_pm}";
  }
}