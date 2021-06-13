import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../models/question.dart';
import '../resultspage/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({Key? key, required this.questions, required this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            showDialog<bool>(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Text(
                        "Are you sure you want to quit the quiz? All your progress will be lost."),
                    title: Text("Warning!"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      FlatButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ],
                  );
                });
          },
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title:
            Text(widget.category.name, style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Text("${_currentIndex + 1}"),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                HtmlUnescape().convert(
                                    widget.questions[_currentIndex].question),
                                softWrap: true,
                                style: MediaQuery.of(context).size.width > 800
                                    ? _questionStyle.copyWith(fontSize: 30.0)
                                    : _questionStyle.copyWith(
                                        color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ...options.map((option) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: RadioListTile(
                                        title: Text(
                                          HtmlUnescape().convert("$option"),
                                          style: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? TextStyle(fontSize: 30.0)
                                              : TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        groupValue: _answers[_currentIndex],
                                        value: option,
                                        onChanged: (value) {
                                          setState(() {
                                            _answers[_currentIndex] = option;
                                          });
                                        },
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            child: ButtonTheme(
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 0,
                padding: MediaQuery.of(context).size.width > 800
                    ? const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 64.0)
                    : null,
                child: Text(
                  _currentIndex == (widget.questions.length - 1)
                      ? "Submit"
                      : "Next",
                  style: MediaQuery.of(context).size.width > 800
                      ? TextStyle(fontSize: 30.0)
                      : TextStyle(color: Colors.white),
                ),
                onPressed: _nextSubmit,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState!.showSnackBar(SnackBar(
        content: Text("You must select an answer to continue."),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => FinishedQuizPage(
              questions: widget.questions, answers: _answers)));
    }
  }
}
