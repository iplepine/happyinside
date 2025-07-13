import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SleepHomePage extends StatelessWidget {
  const SleepHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수면 기록'), centerTitle: true),
      body: const Center(child: Text('수면 기록 목록이 여기에 표시됩니다.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/sleep-record');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
