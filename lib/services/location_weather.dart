import 'package:http/http.dart';
import 'dart:convert';
import 'package:world_time/services/internet.dart';

class LocationWeather {
  final String _apiKey =
      "6694a30fde72dd737c4d77c63c748b69"; //api-key from API provider

  double lat = 0, lon = 0;
  Map _data = {};
  String icon = "", temperature = "", description = "", address = "";

  LocationWeather({this.lon, this.lat});

  Internet _internet = Internet(); // create an Internet instance

  _convertKelvin(double kelvin) {
    
    double celsius = kelvin - 273.15;
    return celsius.toInt().toString();
  }

  Future<void> getWeatherData() async {
    try {
      if (await _internet.isConnected() == null) {
        print(_internet.errorMessage);
      } else {
        Response response = await get(
            "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey");

        print('weather - ${response.statusCode}');
        if (response.statusCode == 200) {
          _data = jsonDecode(response.body);
          
          print(_data);
          icon = _data['weather'][0]['icon'];
          temperature = _convertKelvin(_data['main']['temp']);
          description = _data['weather'][0]['description'];
          address = _data['name'];

        } else {
          print(response.statusCode);
        }
      }
    } catch (e) {
      print("Weather Error occurred $e");
    }
  }
}
