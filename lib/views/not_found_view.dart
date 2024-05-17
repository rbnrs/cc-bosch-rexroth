import 'package:flutter/material.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "404 Not found",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
