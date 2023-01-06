import 'package:flutter/material.dart';

class LoadingFailed extends StatelessWidget {
  LoadingFailed({
    Key? key,
    this.message = 'Loading failed!',
    required Future<void> Function() refreshOption
  }) : refreshFunction=refreshOption,super(key: key);

  final String message;
  Future<void> Function() refreshFunction;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    displacement: 80,
      onRefresh: refreshFunction,
      child:Stack(
        children: <Widget>[ListView(),Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swipe_down),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )],
      ),
  );
}
