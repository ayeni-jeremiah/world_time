import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  static Map data = {}; //save all data gotten from the loading route
  Color bgColor = data['isDay'] == true ? Colors.amber[400] : Colors.amber[600];

  @override
  Widget build(BuildContext context) {
    // dataKeep = ModalRoute.of(context).settings.arguments;
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: bgColor,
        onPressed: () async {
          final waitingData = await Navigator.pushNamed(context, '/choose',
              arguments: {'cityList': data['cityList'], 'bgColor': bgColor});
          setState(() {
            if (waitingData != null) {
              data = waitingData;
              print("$waitingData");
            }
          });
        },
        child: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: FlipCard(
          key: cardKey,
          // flipOnTouch: false,
          front: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${data['temperature']} \u{00B0}",
                          style:
                              TextStyle(fontSize: 150.0, fontFamily: 'Lobster'),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.black12,
                              child: Image(
                                  color: Colors.black,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'http://openweathermap.org/img/wn/${data['icon']}@2x.png')),
                            ),
                            Text(
                              "${data['description']}",
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: 'Lobster',), softWrap: true,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            showInfo(),
                            SizedBox(
                              height: 10.0,
                            ),
                            showTime(),
                            SizedBox(
                              height: 5.0,
                            ),
                            Divider(
                              thickness: 0.0,
                              indent: 40.0,
                              endIndent: 40.0,
                              color: Colors.amberAccent[100],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            showDate()
                          ],
                        ))),
              ],
            ),
          ),
          back: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: Image(
                                  // color: Colors.black,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://www.countryflags.io/${data['countryCode']}/shiny/64.png')),
                            ),
                            Text(
                              "${data['country']}",
                              style: TextStyle(
                                  fontFamily: 'Lobster',
                                  wordSpacing: 3.0,
                                  fontSize: 40),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("${data['state']},",
                                style: TextStyle(
                                    fontFamily: 'Lobster',
                                    wordSpacing: 3.0,
                                    fontSize: 30)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("${data['address']},",
                                style: TextStyle(
                                    fontFamily: 'Lobster',
                                    wordSpacing: 3.0,
                                    fontSize: 20))
                          ]),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            showInfo(),
                            SizedBox(
                              height: 10.0,
                            ),
                            showTime(),
                            SizedBox(
                              height: 5.0,
                            ),
                            Divider(
                              thickness: 0.0,
                              indent: 40.0,
                              endIndent: 40.0,
                              color: Colors.amberAccent[100],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            showDate()
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showInfo() => Text("Request Country Date/Time:",
      style: TextStyle(fontSize: 18.0, color: bgColor, fontFamily: 'Lobster'));
  showTime() => Text(data['time'],
      style: TextStyle(fontSize: 50.0, color: bgColor, fontFamily: 'Lobster'));
  showDate() => Text(data['date'],
      style: TextStyle(fontSize: 30.0, color: bgColor, fontFamily: 'Lobster'));
}
