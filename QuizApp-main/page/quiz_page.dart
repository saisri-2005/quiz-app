import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/question.dart';

class QuizPage extends StatefulWidget {
  final Category category;
  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  int score = 0;

  void _selectOption(int index) {
    final question = widget.category.questions[currentIndex];
    if (question.selectedIndex == null) {
      setState(() {
        question.selectedIndex = index;
        if (index == question.correctIndex) score++;
      });
    }
  }

  void _nextQuestion() {
    if (currentIndex < widget.category.questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Text('Your score: $score / ${widget.category.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Topics'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.category.questions[currentIndex];
    final isAnswered = q.selectedIndex != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Question ${currentIndex + 1} of ${widget.category.questions.length}',
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  q.questionText,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),

                // Options
                ...List.generate(q.options.length, (index) {
                  final isSelected = q.selectedIndex == index;
                  final isCorrect = q.correctIndex == index;

                  Color optionColor = Colors.white;
                  if (isAnswered) {
                    if (isCorrect) {
                      optionColor = Colors.green.shade300;
                    } else if (isSelected && !isCorrect) {
                      optionColor = Colors.red.shade300;
                    }
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: optionColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: InkWell(
                      onTap: () => _selectOption(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        child: Row(
                          children: [
                            // Option label (A, B, C, D)
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                q.options[index],
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ),
                            if (isAnswered && isCorrect)
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                            if (isAnswered &&
                                isSelected &&
                                !isCorrect)
                              const Icon(Icons.cancel, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: isAnswered ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  child: Text(
                    currentIndex == widget.category.questions.length - 1
                        ? 'Finish Quiz'
                        : 'Next Question',
                    style:
                    const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Score: $score',
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
