import 'package:http/http.dart';
import 'dart:convert';
import 'package:world_time/services/internet.dart';
import 'package:intl/intl.dart';
import 'package:world_time/services/api.dart';

class LocationTime {
  final String _key = apikey["time"]; //api-key from API provider

  double lon = 0, lat = 0; //latitude and longitude from mobile/user
  Map _data = {}; //Location API data;
  String time = "", date = "", country = "", countryCode = "", state = "";
  bool isDay = false;

  LocationTime({this.lon, this.lat});

  Internet _internet = Internet(); // create an Internet instance

  Future<void> getTime() async {
    try {
      if (_internet.isConnected() == null) {
        print(_internet.errorMessage);
      } else {
        Response response = await get(
            "http://api.geonames.org/timezoneJSON?lat=$lat&lng=$lon&username=$_key");

        print('time - ${response.statusCode}');
        if (response.statusCode == 200) {
          _data = jsonDecode(response.body);
          print(_data);
          DateTime now = DateTime.parse(_data['time']);

          //OFFSET NO LONGER NEEDED, time is precise
          // var offset = _data['gmtOffset'].toString();

          // //adding offset to DateTime
          // if (offset.contains(".")) {
          //   var hoursMinutes = offset.split('.'); //check if offset is decimal

          //   now = now.add(Duration(
          //       hours: int.parse(hoursMinutes[0]))); //first decimal is hours
          //   now = now.add(Duration(
          //       minutes: int.parse(hoursMinutes[1]))); //second is minutes
          // } else {
          //   now = now.add(Duration(hours: int.parse(offset)));
          // }

          // print(now);
          isDay = now.hour > 5 && now.hour < 17 ? true : false;
          time = DateFormat.jm().format(
              now); //convert dateTime using Intl Package to AM/PM format
          date = DateFormat.yMMMMEEEEd().format(
              now); //convert dateTime using Intl Package to readable date format
          country = _data['countryName'];
          countryCode = _data['countryCode'];
          state = _data['timezoneId']
              .toString()
              .split("/")[1]
              .trim()
              .replaceAll(new RegExp(r'_'), ' ');
        }
      }
    } catch (e) {
      print("Time Error $e");
    }
  }
}
