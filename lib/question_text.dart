import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  final String questionText;

  const QuestionText({super.key, required this.questionText});

  @override
  Widget build(BuildContext context) {
    return Text(
      questionText,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}
