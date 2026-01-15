import 'package:flutter/material.dart';
import 'models.dart';
import 'question_text.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  Answer? selectedAnswer;

  final List<Question> questions = [
    Question(
      question: 'Quelle entreprise développe Flutter ?',
      answers: [
        Answer(text: 'Google', isCorrect: true),
        Answer(text: 'Apple', isCorrect: false),
        Answer(text: 'Microsoft', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel langage est utilisé avec Flutter ?',
      answers: [
        Answer(text: 'Kotlin', isCorrect: false),
        Answer(text: 'Dart', isCorrect: true),
        Answer(text: 'Swift', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel est le but de Flutter ?',
      answers: [
        Answer(text: 'Créer des applications mobiles', isCorrect: true),
        Answer(text: 'Créer des applications web', isCorrect: false),
        Answer(text: 'Créer des applications desktop', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel widget est utilisé pour organiser les éléments verticalement ?',
      answers: [
        Answer(text: 'Column', isCorrect: true),
        Answer(text: 'Row', isCorrect: false),
        Answer(text: 'Stack', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel widget est utilisé pour organiser les éléments horizontalement ?',
      answers: [
        Answer(text: 'Row', isCorrect: true),
        Answer(text: 'Column', isCorrect: false),
        Answer(text: 'Padding', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel widget offre une structure visuelle de base comme l\'AppBar ?',
      answers: [
        Answer(text: 'Scaffold', isCorrect: true),
        Answer(text: 'MaterialApp', isCorrect: false),
        Answer(text: 'Container', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quelle fonction est le point d\'entrée d\'une application Flutter ?',
      answers: [
        Answer(text: 'main()', isCorrect: true),
        Answer(text: 'runApp()', isCorrect: false),
        Answer(text: 'init()', isCorrect: false),
      ],
    ),
    Question(
      question: 'Comment appelle-t-on un widget qui peut changer d\'état ?',
      answers: [
        Answer(text: 'StatefulWidget', isCorrect: true),
        Answer(text: 'StatelessWidget', isCorrect: false),
        Answer(text: 'InheritedWidget', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel widget permet de créer un espace vide de taille fixe ?',
      answers: [
        Answer(text: 'SizedBox', isCorrect: true),
        Answer(text: 'Padding', isCorrect: false),
        Answer(text: 'Spacer', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Comment s\'appelle le gestionnaire de paquets officiel de Dart ?',
      answers: [
        Answer(text: 'pub.dev', isCorrect: true),
        Answer(text: 'npm', isCorrect: false),
        Answer(text: 'maven', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel mot-clé est utilisé pour déclarer une variable constante à la compilation ?',
      answers: [
        Answer(text: 'const', isCorrect: true),
        Answer(text: 'final', isCorrect: false),
        Answer(text: 'var', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel widget est utilisé pour aligner ses enfants verticalement ?',
      answers: [
        Answer(text: 'Column', isCorrect: true),
        Answer(text: 'Row', isCorrect: false),
        Answer(text: 'Stack', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel widget est utilisé pour aligner ses enfants horizontalement ?',
      answers: [
        Answer(text: 'Row', isCorrect: true),
        Answer(text: 'Column', isCorrect: false),
        Answer(text: 'List', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel widget permet d\'ajouter du rembourrage autour d\'un autre widget ?',
      answers: [
        Answer(text: 'Padding', isCorrect: true),
        Answer(text: 'Margin', isCorrect: false),
        Answer(text: 'Border', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel widget permet de rendre un autre widget cliquable ?',
      answers: [
        Answer(text: 'GestureDetector', isCorrect: true),
        Answer(text: 'ClickListener', isCorrect: false),
        Answer(text: 'Button', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Comment s\'appelle l\'outil de ligne de commande pour vérifier les erreurs de code ?',
      answers: [
        Answer(text: 'flutter analyze', isCorrect: true),
        Answer(text: 'flutter check', isCorrect: false),
        Answer(text: 'flutter lint', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel widget est utilisé pour afficher une image ?',
      answers: [
        Answer(text: 'Image', isCorrect: true),
        Answer(text: 'Picture', isCorrect: false),
        Answer(text: 'Icon', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel widget permet de faire défiler une liste d\'éléments ?',
      answers: [
        Answer(text: 'ListView', isCorrect: true),
        Answer(text: 'ScrollView', isCorrect: false),
        Answer(text: 'Column', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel mot-clé permet d\'importer une bibliothèque en Dart ?',
      answers: [
        Answer(text: 'import', isCorrect: true),
        Answer(text: 'include', isCorrect: false),
        Answer(text: 'require', isCorrect: false),
      ],
    ),
    Question(
      question:
          'Quel widget est utilisé pour superposer des widgets les uns sur les autres ?',
      answers: [
        Answer(text: 'Layer', isCorrect: false),
        Answer(text: 'Overlay', isCorrect: false),
        Answer(text: 'Stack', isCorrect: true),
      ],
    ),
  ];

  void selectAnswer(Answer answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void submitAnswer() {
    if (selectedAnswer == null) return;

    bool isCorrect = selectedAnswer!.isCorrect;

    if (isCorrect) {
      score++;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isCorrect ? Icons.check : Icons.close, color: Colors.white),
            const SizedBox(width: 10),
            Text(isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse...'),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    setState(() {
      selectedAnswer = null;
      currentQuestion++;
    });
  }

  @override
  void initState() {
    super.initState();
    for (var question in questions) {
      question.answers.shuffle();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Résultat'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score final : $score / ${questions.length}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentQuestion = 0;
                      score = 0;
                      selectedAnswer = null;
                    });
                  },
                  child: const Text('Rejouer'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Flutter'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Question ${currentQuestion + 1} sur ${questions.length}',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              QuestionText(questionText: question.question),
              const SizedBox(height: 20),
              ...question.answers.map((answer) {
                final isSelected = selectedAnswer == answer;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => selectAnswer(answer),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: isSelected
                          ? Colors.white
                          : Colors.white.withAlpha(204),
                      foregroundColor: Colors.deepPurple,
                      side: isSelected
                          ? const BorderSide(color: Colors.deepPurple, width: 3)
                          : BorderSide.none,
                    ),
                    child: Text(
                      answer.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: selectedAnswer == null ? null : submitAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text('Suivant', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
