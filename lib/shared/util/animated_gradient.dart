import 'dart:async';
import 'package:flutter/material.dart';


class AnimatedGradient extends StatefulWidget {
  const AnimatedGradient({Key? key,required this.child}) : super(key: key);
  final Widget? child;
  @override
  State<AnimatedGradient> createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient>{

  var counter = 0;

  List<Color> get getColorsList => [
    const Color(0xFF424549),
    const Color(0xFF36393E),
    //const Color(0xFF7289DA),
    const Color(0xFF282B30),
    const Color(0xFF1E2124),
  ]..shuffle();

  List<Alignment> get getAlignments => [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];

  Timer? _timer;

  _startBgColorAnimationTimer() {
    ///Animating for the first time.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      counter++;
      setState(() {});
    });

    const interval = Duration(seconds: 10);
    _timer = Timer.periodic(
      interval,
          (Timer timer) {
        counter++;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startBgColorAnimationTimer();
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: getAlignments[counter % getAlignments.length],
        end: getAlignments[(counter + 2) % getAlignments.length],
        colors: getColorsList,
        tileMode: TileMode.mirror,
      ),
    ),
    duration: const Duration(seconds: 10),
    child: widget.child,
  );
}