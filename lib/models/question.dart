enum Type { multiple, boolean }

enum Difficulty { easy, medium, hard }

class Question {
  final String categoryName;
  final Type type;
  final Difficulty difficulty;
  final String question;
  final String correctAnswer;
  final List<dynamic> incorrectAnswers;

  Question(
      {required this.categoryName,
      required this.type,
      required this.difficulty,
      required this.question,
      required this.correctAnswer,
      required this.incorrectAnswers});

  Question.fromMap(Map<String, dynamic> data)
      : categoryName = data["category"],
        type = data["type"] == "multiple" ? Type.multiple : Type.boolean,
        difficulty = data["difficulty"] == "easy"
            ? Difficulty.easy
            : data["difficulty"] == "medium"
                ? Difficulty.medium
                : Difficulty.hard,
        question = data["question"],
        correctAnswer = data["correct_answer"],
        incorrectAnswers = data["incorrect_answers"];

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromMap(question)).toList();
  }
}
