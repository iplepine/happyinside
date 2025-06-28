import 'package:flutter/material.dart';
import '../../../../shared/widgets/loading_widget.dart';

/// 계산기 페이지
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  String _operation = '+';
  double? _result;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  void _calculate() {
    final first = double.tryParse(_firstController.text);
    final second = double.tryParse(_secondController.text);

    if (first == null || second == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 숫자를 입력해주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: UseCase 호출
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
        _result = first + second; // 임시 계산
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계산기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '첫 번째 숫자',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _operation,
              decoration: const InputDecoration(
                labelText: '연산',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '+', child: Text('더하기')),
                DropdownMenuItem(value: '-', child: Text('빼기')),
                DropdownMenuItem(value: '*', child: Text('곱하기')),
                DropdownMenuItem(value: '/', child: Text('나누기')),
              ],
              onChanged: (value) {
                setState(() {
                  _operation = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _secondController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '두 번째 숫자',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _calculate,
              child: const Text('계산하기'),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const LoadingWidget(message: '계산 중...')
            else if (_result != null)
              Text(
                '결과: $_result',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          ],
        ),
      ),
    );
  }
} 