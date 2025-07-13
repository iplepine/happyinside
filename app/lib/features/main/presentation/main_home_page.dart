import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Happy Inside')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.push('/happy');
              },
              child: const Text('Happy Record'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/sleep');
              },
              child: const Text('Sleep Record'),
            ),
          ],
        ),
      ),
    );
  }
}
