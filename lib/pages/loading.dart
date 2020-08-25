import 'dart:async';

import 'package:flutter/material.dart';
import 'package:world_time/services/internet.dart';
import 'package:world_time/services/locator.dart';
import 'package:world_time/services/location_time.dart';
import 'package:world_time/services/location_weather.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_time/services/cities.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<Cities> cityList = []; //has all cities Instances
  String readyText = "Getting Things Ready...";

  final _scaffoldKey = GlobalKey<ScaffoldState>(); //to save the context

  getData() async {
    Locator locator = Locator();
    await locator.getCurrentLocation();

    Internet _internet = Internet(); //verify Internet

    LocationTime locationTime =
        LocationTime(lat: locator.lat, lon: locator.lon);
    LocationWeather locationWeather =
        LocationWeather(lat: locator.lat, lon: locator.lon);

    if (await _internet.isConnected() != null) {
      await locationWeather.getWeatherData();
      await locationTime.getTime();

      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'address': locationWeather.address,
          'description': locationWeather.description,
          'icon': locationWeather.icon,
          'temperature': locationWeather.temperature,
          'country': locationTime.country,
          'date': locationTime.date,
          'time': locationTime.time,
          'isDay': locationTime.isDay,
          'countryCode': locationTime.countryCode,
          'state': locationTime.state,
          'cityList': cityList
        });
      });
    } else {
      setState(() {
        readyText = _internet.errorMessage;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            SpinKitChasingDots(
              color: Colors.white70,
              size: 20.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text("No Internet Connection, waiting...")
          ],
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    convertCitiesToList();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.amber,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Weather and Time App!',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lobster',
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            SpinKitCircle(
              color: Colors.black,
              size: 50.0,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              readyText,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 18.0,
                  fontFamily: 'Lobster'),
            )
          ],
        ),
      )),
    );
  }

  convertCitiesToList() async {
    if (cityList.isEmpty) {
      dynamic data2 = await DefaultAssetBundle.of(context)
          .loadString('assets/city.list.json');

      var ddd = await jsonDecode(data2);
      setState(() {
        cityList =
            (ddd as List).map((data) => new Cities.fromJson(data)).toList();
      });
    }
  }
}
