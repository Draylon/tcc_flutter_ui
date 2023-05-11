import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:ui/shared/util/animated_gradient.dart';

class GradientIntroScreen extends IntroScreen {
  GradientIntroScreen({
  required super.onbordingDataList,
  super.pageRoute,
  required super.colors,
  required super.nextButton,
  required super.lastButton,
  required super.skipButton,
  super.selectedDotColor,
  super.unSelectdDotColor,
  });

  @override
  void skipPage(BuildContext context) {
    Navigator.pushReplacement(context, pageRoute!);
  }

  @override
  IntroScreenState createState() {
    return GradientIntroScreenState();
  }
}

class GradientIntroScreenState extends IntroScreenState {

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == widget.onbordingDataList.length - 1) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  Widget _buildPageIndicator(int page) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: page == currentPage ? 10.0 : 6.0,
      width: page == currentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: page == currentPage
            ? (widget.selectedDotColor ?? Colors.blue)
            : (widget.unSelectdDotColor ?? Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradient(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 15,
              child: PageView(
                controller: controller,
                onPageChanged: _onPageChanged,
                children: widget.onbordingDataList,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: lastPage ? const Text("") : widget.skipButton,
                    onPressed: () => lastPage
                        ? null
                        : widget.skipPage(
                      context,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                        children: List.generate(
                            widget.onbordingDataList.length,
                                (index) => _buildPageIndicator(index))),
                  ),
                  TextButton(
                    child: lastPage ? widget.lastButton : widget.nextButton,
                    onPressed: () => lastPage
                        ? widget.skipPage(context)
                        : controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}