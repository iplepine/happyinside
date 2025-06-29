import 'package:flutter/material.dart';

/// 행복한 순간 작성 화면 (MVP)
class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('행복 기록 작성'),
      ),
      body: const Center(
        child: Text('여기에 작성 폼이 들어갑니다.'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // 저장 로직 (추후 구현)
          },
          child: const Text('저장'),
        ),
      ),
    );
  }
} 