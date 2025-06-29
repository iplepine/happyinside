import 'package:flutter/material.dart';
import '../../happy_record/presentation/write/write_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('해피 인사이드')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('행복 기록 작성하기'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const WritePage(),
              ),
            );
          },
        ),
      ),
    );
  }
} 