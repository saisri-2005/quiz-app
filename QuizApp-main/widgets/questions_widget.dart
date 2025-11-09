import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final Function(int) onOptionTap;
  final VoidCallback onNext;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onOptionTap,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(question.questionText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ...List.generate(question.options.length, (i) {
          final isSelected = question.selectedIndex == i;
          Color fill = Colors.white;
          if (question.selectedIndex != null) {
            if (i == question.correctIndex) fill = Colors.green.shade300;
            else if (isSelected) fill = Colors.red.shade300;
          }
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fill,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              onPressed: question.selectedIndex == null ? () => onOptionTap(i) : null,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(question.options[i], style: const TextStyle(fontSize: 16)),
              ),
            ),
          );
        }),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: onNext,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
            child: Text('Next Question', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}


