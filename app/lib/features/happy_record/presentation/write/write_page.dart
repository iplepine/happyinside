import 'package:flutter/material.dart';
import '../../../../core/models/record.dart';
import '../../../../di/injection.dart';
import '../../domain/usecases/add_record_usecase.dart';

/// 행복한 순간 작성 화면 (MVP)
class WritePage extends StatefulWidget {
  final int? initialScore;
  const WritePage({super.key, this.initialScore});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _tagController = TextEditingController();
  int _intensity = 3;
  final List<String> _tags = [];

  // 자주 사용할 만한 태그 예시
  final List<String> _suggestedTags = [
    '가족',
    '친구',
    '자연',
    '산책',
    '커피',
    '음악',
    '여행',
    '운동',
    '독서',
    '맛집',
    '휴식',
    '성취',
    '반려동물',
    '취미',
    '감사',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialScore != null) {
      _intensity = widget.initialScore!;
    }
    // 진입 후 바로 포커스 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final record = Record(
        id: UniqueKey().toString(),
        content: _contentController.text,
        intensity: _intensity,
        tags: List<String>.from(_tags),
        createdAt: DateTime.now(),
        location: null, // 위치 정보 입력 UI 필요
        photos: const [], // 사진 입력 UI 필요
      );
      // UseCase를 통한 저장
      final addRecordUseCase = Injection.getIt<AddRecordUseCase>();
      await addRecordUseCase(record);

      // async 처리 후 context 사용 시 mounted 체크
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) return;
    if (!_tags.contains(trimmed)) {
      setState(() {
        _tags.add(trimmed);
      });
    }
    _tagController.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('행복 기록 작성')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // 내용 입력
              TextFormField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '행복했던 순간을 기록해보세요',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '내용을 입력하세요' : null,
              ),
              const SizedBox(height: 24),
              // 감정 강도(점수)
              Row(
                children: [
                  const Text(
                    '행복 점수',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: _intensity.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_intensity',
                      onChanged: (v) => setState(() => _intensity = v.round()),
                    ),
                  ),
                  Text('$_intensity점'),
                ],
              ),
              const SizedBox(height: 24),
              // 태그 추천 칩
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _suggestedTags.map((tag) {
                  final selected = _tags.contains(tag);
                  return ChoiceChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (selected) {
                      if (selected) _addTag(tag);
                    },
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha(51),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              // 현재 선택된 태그 칩
              if (_tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _tags
                      .map(
                        (tag) => GestureDetector(
                          onTap: () => _removeTag(tag),
                          child: Chip(
                            label: Text(
                              tag,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 8),
              // 태그 입력 (엔터로 추가)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        labelText: '태그 입력',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _addTag,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addTag(_tagController.text),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 48),
                    ),
                    child: const Text('추가'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 위치, 사진 등은 실제 구현 시 추가
              // 예시: 위치/사진 추가 버튼 등
              // ...
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
