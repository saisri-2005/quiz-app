class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  int? selectedIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.selectedIndex,
  });

  String get correctAnswer => options[correctIndex]; // optional helper
}

