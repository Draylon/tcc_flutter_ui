import 'package:flutter/material.dart';
import 'package:ui/pages/cardPage.dart';
import 'package:ui/pages/paging.dart';

void main() {
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
      home: CardPage(title: 'Flutter App main page'),
    );
  }
}

