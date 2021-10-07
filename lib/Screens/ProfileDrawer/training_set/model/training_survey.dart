// To parse this JSON data, do
//
//     final trainingSurvey = trainingSurveyFromJson(jsonString);

import 'dart:convert';

TrainingSurvey trainingSurveyFromJson(String str) => TrainingSurvey.fromJson(json.decode(str));

String trainingSurveyToJson(TrainingSurvey data) => json.encode(data.toJson());

class TrainingSurvey {
  TrainingSurvey({
    this.question,
    this.answers,
    this.correctAnswerIndex,
  });

  String question;
  List<String> answers;
  int correctAnswerIndex;

  factory TrainingSurvey.fromJson(Map<String, dynamic> json) => TrainingSurvey(
    question: json["question"],
    answers: List<String>.from(json["answers"].map((x) => x)),
    correctAnswerIndex: json["correctAnswerIndex"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answers": List<dynamic>.from(answers.map((x) => x)),
    "correctAnswerIndex": correctAnswerIndex,
  };
}
