import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/pages/cardPage.dart';
import 'package:ui/pages/map_paging.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ui/shared/util/gradient_introScreen.dart';
import 'package:ui/shared/util/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';

//StreamSubscription? mqttStreamSubscription;
//final mqttServerClient = MqttServerClient.withPort('test.mosquitto.org','user_hyqnap5637',1883,maxConnectionAttempts: 3);

//WORKMANAGER
//WORKMANAGER
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((String task,Map<String,dynamic>? inputData) async {
    print("periodic task_?");
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = const IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = InitializationSettings(android: android,iOS: IOS);
    flip.initialize(settings);
    await queryGeneralNotificationChannel(flip);
    return Future.value(true);
  });
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SharedPreferences.getInstance();
  await SharedPreferences.getInstance().then((prefs) => {
    doneIntro = prefs.getBool('intro_screen')
  });

  //notifications worker
  Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true // FLAG

  );
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",
    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",
    frequency: const Duration(minutes: 15),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    backoffPolicy: BackoffPolicy.linear,
    constraints: Constraints(
      networkType: NetworkType.connected,
    )
  );

  runApp(const MyApp());
}

/**
 * Login with google + login screen
 * https://www.youtube.com/watch?v=1U8_Mq1QdX4&ab_channel=MitchKoko
 * https://www.youtube.com/watch?v=Dh-cTQJgM-Q&ab_channel=MitchKoko
 */

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        backgroundColor: const Color(0xfff8f4ea),
        bottomAppBarColor: const Color(0xff144272),
        accentColor: const Color(0xff397ed2),
        primaryColor: Colors.white,
        brightness: Brightness.light,
        primaryColorDark: Colors.black,
        appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),),
      darkTheme: ThemeData(
          backgroundColor: const Color(0xff1e2124),
          bottomAppBarColor: const Color(0xff282b30),
          hintColor: const Color(0xff36393e),
          accentColor: const Color(0xff424549),
          buttonColor: const Color(0xff7289da),

          primarySwatch: Colors.blueGrey,
          cardColor: const Color(0xff2c2f33),

          primaryColor: Colors.white,
          primaryColorDark: Colors.white,

          brightness: Brightness.dark,

          primaryColorLight: Colors.black,
          indicatorColor: Colors.white,
          // next line is important!
          appBarTheme: AppBarTheme(brightness: Brightness.dark)
      ),
      home: MainAppStateful(),
    );
  }
}

class MainAppStateful extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainAppState();
}

bool? doneIntro=false;

class _MainAppState extends State<MainAppStateful>{
  @override
  void initState() {
    super.initState();

    //check for update <github>?
    FlutterNativeSplash.remove();
  }


  @override
  Widget build(BuildContext context) {
    return doneIntro==true?
      CardPage(title: 'Flutter App main page')
        :_gradientIntro();
  }
}

_gradientIntro() => GradientIntroScreen(
  onbordingDataList: [
    OnbordingData(
      image: Image.network("https://cdn-icons-png.flaticon.com/512/6959/6959474.png").image,//AssetImage("assets/logo1.png"),
      imageHeight: 150,
      imageWidth: 150,
      titleText:Text("Bem vindo ao app",style: TextStyle(
        fontSize: 40,
        wordSpacing: 5,
        fontFamily: "Verdana",
        letterSpacing: 5,
      ),),
      descText: Row(
        children: [
          Expanded(child: Text(""),flex: 1,),
          Expanded(child: Text("Consulte informação pertinente a condições do ar, agua, etc. em determinadas regiões",style: TextStyle(
            fontSize: 25,
            wordSpacing: 5,
            fontFamily: "Verdana",
          ),
          textAlign: TextAlign.center
          ),flex: 8,),
          Expanded(child: Text(""),flex: 1,),
        ],
      )
    ),
    OnbordingData(
        image: Image.network("https://cdn-icons-png.flaticon.com/512/2238/2238049.png").image,//AssetImage("assets/logo1.png"),
        imageHeight: 250,
        imageWidth: 250,
        titleText:Text("Propósito",style: TextStyle(
          fontSize: 40,
          wordSpacing: 5,
          fontFamily: "Verdana",
          letterSpacing: 5,
        ),),
        descText: Row(
          children: [
            Expanded(child: Text(""),flex: 1,),
            Expanded(child: Text("Este aplicativo foi desenvolvido como parte de um trabalho de iniciação científica 🙃",style: TextStyle(
              fontSize: 25,
              wordSpacing: 5,
              fontFamily: "Verdana",
            ),
                textAlign: TextAlign.center
            ),flex: 8,),
            Expanded(child: Text(""),flex: 1,),
          ],
        )
    ),
    OnbordingData(
        image: Image.network("https://cdn-icons-png.flaticon.com/512/3696/3696584.png").image,//AssetImage("assets/logo1.png"),
        imageHeight: 250,
        imageWidth: 250,
        titleText:Text("Benefícios",style: TextStyle(
          fontSize: 40,
          wordSpacing: 5,
          fontFamily: "Verdana",
          letterSpacing: 5,
        ),),
        descText: Row(
          children: [
            Expanded(child: Text(""),flex: 1,),
            Expanded(child: Text("Conservar recursos\nSistemas de aviso prévio/alarmes\nInformação compreensível, para tomada de decisão logística",style: TextStyle(
              fontSize: 25,
              wordSpacing: 5,
              fontFamily: "Verdana",
            ),
                textAlign: TextAlign.center
            ),flex: 8,),
            Expanded(child: Text(""),flex: 1,),
          ],
        )
    ),
  ],
  colors: const [
    //list of colors for per pages
    Colors.white, Colors.red,
  ],
  pageRoute: MaterialPageRoute(
    maintainState: false,

    builder: (context) => CardPage(title: 'Flutter App main page'),
  ),
  nextButton: const Padding(
    padding: EdgeInsets.all(10),
    child:  Text(
      "NEXT",
      style: TextStyle(
        fontSize: 23,
        color: Colors.white,
      ),
    ),
  ),
  lastButton: const Padding(
    padding: EdgeInsets.all(10),
    child:  Text(
      "GOT IT",
      style: TextStyle(
        fontSize: 23,
        color: Colors.white,
      ),
    ),
  ),
  skipButton: const Padding(
    padding: EdgeInsets.all(10),
    child:  Text(
      "SKIP",
      style: TextStyle(
        fontSize: 23,
        color: Colors.white,
      ),
    ),
  ),
  selectedDotColor: Colors.orange,
  unSelectdDotColor: Colors.grey,
);


