import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(App());

final primaryColor = const Color(0xFF2E279D);
final secondaryColor = const Color(0xFF46B3E6);
final txtColor = const Color(0xFFDFF6F0);
bool timerIsRunning = false;
bool hastimerEnded = false;
AnimationController controller;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4ocus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int time = 0;
  int points = 0;
  int i = 0;

  String get timerString {
    Duration duration = controller.duration * controller.value;

    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    var flutterNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initSettings = new InitializationSettings(android, iOS);
    flutterNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);

    controller = AnimationController(
      duration: Duration(minutes: time),
      vsync: this,
    );

    WidgetsBinding.instance.addObserver(this);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('nigger'),
              content: Text('$payload'),
            ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        print('Pasued State');
        showNotification();

        break;
      case AppLifecycleState.resumed:
        print('Resumed State');
        break;
      case AppLifecycleState.inactive:
        print('Inactive State');
        break;
      case AppLifecycleState.detached:
        print('Detached State');
        break;
    }
  }

  void _startTimer() {
    setState(() {
      timerIsRunning = true;
    });

    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);

    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    controller.addListener(() {
      if (controller.isDismissed) {
        setState(() {
          timerIsRunning = false;
          hastimerEnded = true;
        });
      }
    });
  }

  // void _endTimer() {

  //   AlertDialog(
  //     title: Text("Your'e not done yet!"),
  //     content: ,

  //   )
  //   controller.stop();
  //   setState(() {
  //     timerIsRunning = false;
  //   });
  // }

  Future<void> _endTimer() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You're not done yet"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want'),
                Text("You won't get any 4ocus points!"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                setState(() {
                  timerIsRunning = false;
                  controller.stop();
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addPoints() {
    if (hastimerEnded == true) {
      points += 10;
      hastimerEnded = false;
    }
  }

  void showNotification() async {
    var android = new AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await FlutterLocalNotificationsPlugin()
        .show(0, 'nigger', 'nigger get up', platform);
  }

  _getCustomAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: secondaryColor),
        child: Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            SizedBox(width: 15),
            Row(
              children: <Widget>[
                Text(
                  'Points: ',
                  style: TextStyle(
                      height: 4,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: txtColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '$points',
                  style: TextStyle(
                      height: 4,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: txtColor),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _setButton() {
    if (!timerIsRunning) {
      timerIsRunning = false;

      return FlatButton(
        onPressed: () {
          _startTimer();
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(5.2, 2.0),
                    blurRadius: 2)
              ]),
          child: Text(
            'Start',
            style: TextStyle(color: txtColor, fontSize: 30),
          ),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.18,
        ),
      );
    } else {
      timerIsRunning = true;
      return FlatButton(
        onPressed: () {
          // _endTimer();
          _endTimer();
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(5.2, 2.0),
                    blurRadius: 2)
              ]),
          child: Text(
            'Stop',
            style: TextStyle(color: txtColor, fontSize: 30),
          ),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.18,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    addPoints();
    return Scaffold(
        appBar: _getCustomAppBar(),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [secondaryColor, primaryColor])),
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            margin: EdgeInsets.only(left: 20),
                            height: 75,
                            width: 100,
                            child: SvgPicture.asset(
                              "assets/cloud_1.svg",
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            margin: EdgeInsets.only(
                              right: 20,
                            ),
                            height: 75,
                            width: 100,
                            child: SvgPicture.asset(
                              "assets/cloud_2.svg",
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SleekCircularSlider(
                        initialValue: 25,
                        appearance: CircularSliderAppearance(
                          size: MediaQuery.of(context).size.width * 0.7,
                          customColors: CustomSliderColors(
                            hideShadow: true,
                            progressBarColors: [secondaryColor, primaryColor],
                            trackColor: secondaryColor,
                          ),
                          customWidths: CustomSliderWidths(
                              trackWidth: 10, progressBarWidth: 17),
                          angleRange: 360,
                          startAngle: 270,
                        ),
                        onChange: (v) {
                          if (!timerIsRunning) {
                            time = (v * 1.21).floor();
                            controller.duration = Duration(seconds: time);
                            controller.value = 1;
                          } else {}
                        },
                        innerWidget: (v) {
                          return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AnimatedBuilder(
                                    animation: controller,
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return Text(
                                        '$timerString',
                                        style: TextStyle(
                                            fontSize: 50, color: txtColor),
                                      );
                                    },
                                  ),
                                  Text(
                                    'Seconds',
                                    style: TextStyle(
                                        fontSize: 25, color: txtColor),
                                  ),
                                ]),
                          );
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              !timerIsRunning ? 'Set a time.' : 'You got this!',
                              style: TextStyle(color: txtColor, fontSize: 30),
                            ),
                            // margin: EdgeInsets.only(bottom: 50),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // width: 200,
                            // height: 100,
                            // padding: EdgeInsets.only(bottom: 10),
                            child: _setButton(),
                            // margin: EdgeInsets.only(top: 50)7
                          ),
                        ],
                      ),
                      // SizedBox(height: 75),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
