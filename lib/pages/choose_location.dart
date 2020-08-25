import 'package:flutter/material.dart';
import 'package:world_time/services/cities.dart';
import 'package:world_time/services/internet.dart';
import 'package:world_time/services/location_time.dart';
import 'package:world_time/services/location_weather.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //to save the context

  static Map data = {}; //recived data passed from home
  List<Cities> _cities = []; //list of all cities
  List<Cities> _citiesKeep = [];
  Color bgColor; //saves background Color

  Internet _internet = Internet(); //verify Internet

  LocationTime locationTime;
  LocationWeather locationWeather;

  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      data = ModalRoute.of(context).settings.arguments;
      bgColor = data['bgColor'];
      _citiesKeep = data['cityList'];
      _cities.addAll(_citiesKeep);
    });

    // print("cities ${_cities.length}");
    // print("cities keep ${_citiesKeep.length}");

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Choose Location"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  value = value.toLowerCase();
                  _filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  // labelText: "Search",
                  hintText: "Search City",
                  prefixIcon: Icon(Icons.search),
                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(25.0)))
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: bgColor,
                    child: ListTile(
                      onTap: () async {
                        if (_internet.isConnected() != null) {
                          _showSelectedInfoSnackBar(
                              "Getting Wather and Time Data...", bgColor);
                          // print('ID: ${_cities[index].id}');
                          // print('NAME: ${_cities[index].name}');
                          // print('COUNTRY CODE: ${_cities[index].countryCode}');
                          await _getSelectedData(
                              double.parse(_cities[index].lat),
                              double.parse(_cities[index].lon));
                          Navigator.pop(context, {
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
                            'cityList': _citiesKeep
                          });
                        } else {
                          _showSelectedInfoSnackBar(
                              "No Internet Connection! Reconnecting...", Colors.redAccent[400]);
                        }
                      },
                      leading: Image(
                          image: NetworkImage(
                              'https://www.countryflags.io/${_cities[index].countryCode}/shiny/32.png')),
                      title: Text('${_cities[index].name}'),
                      subtitle: Text('City ID: ${_cities[index].id}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getSelectedData(lat, lon) async {
    // print('$lon $lat');
    locationTime = LocationTime(lat: lat, lon: lon);
    locationWeather = LocationWeather(lat: lat, lon: lon);

    await locationWeather.getWeatherData();
    await locationTime.getTime();
  }

  Future<void> _showSelectedInfoSnackBar(String message, Color indicatorColor) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(seconds: 4),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: indicatorColor,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            message,
            style: TextStyle(color: bgColor),
          )
        ],
      ),
    ));
  }

  Future<void> _showLoadingCitiesScreen() async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(seconds: 1),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: bgColor,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Searching Cities...",
            style: TextStyle(color: bgColor),
          )
        ],
      ),
    ));
  }

  Future<void> _filterSearchResults(String query) async {
    await _showLoadingCitiesScreen();
    // print(_cities);
    if (query.isNotEmpty) {
      List<Cities> queryResult = List<Cities>();
      _citiesKeep.forEach((item) {
        if (item.name.toLowerCase().contains(query)) {
          queryResult.add(item);
        }
      });
      // print(data);
      setState(() {
        _cities.clear();
        _cities.addAll(queryResult);
      });
      return;
    } else {
      setState(() {
        _cities.clear();
        _cities.addAll(_citiesKeep);
      });
    }
  }
}
