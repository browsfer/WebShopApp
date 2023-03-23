import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.inkDrop(
                color: Theme.of(context).colorScheme.secondary, size: 40),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Logowanie...',
              style: TextStyle(fontSize: 23),
            ),
          ],
        ),
      ),
    );
  }
}
