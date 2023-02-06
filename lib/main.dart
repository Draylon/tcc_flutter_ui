import 'package:flutter/material.dart';
import 'package:ui/pages/cardPage.dart';
import 'package:ui/pages/map_paging.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

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

      ),
      darkTheme: ThemeData(
          backgroundColor: const Color(0xff1e2124),
          bottomAppBarColor: const Color(0xff282b30),
          hintColor: const Color(0xff36393e),
          accentColor: const Color(0xff424549),
          buttonColor: const Color(0xff7289da),

          primarySwatch: Colors.blueGrey,
          cardColor: const Color(0xff2c2f33),

          brightness: Brightness.dark
      ),
      home: MainAppStateful(),
    );
  }
}

class MainAppStateful extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainAppStateful>{
  @override
  void initState() {
    super.initState();

    //check for update <github>?
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return CardPage(title: 'Flutter App main page');
  }

}