import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../sleep_record/presentation/home/widgets/unfinished_sleep_notification.dart';

class MainHomePage extends ConsumerStatefulWidget {
  const MainHomePage({super.key});

  @override
  ConsumerState<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends ConsumerState<MainHomePage> {
  bool _showNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Happy Inside')),
      body: Column(
        children: [
          // 미완성 수면 기록 노티피케이션
          if (_showNotification)
            UnfinishedSleepNotification(
              onDismissed: () {
                if (mounted) {
                  setState(() {
                    _showNotification = false;
                  });
                }
              },
            ),
          const SizedBox(height: 20),
          // 기존 버튼들
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      context.push('/dashboard');
                    },
                    child: const Text('Home Dashboard'),
                  ),
                  const SizedBox(height: 20),
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
          ),
        ],
      ),
    );
  }
}
