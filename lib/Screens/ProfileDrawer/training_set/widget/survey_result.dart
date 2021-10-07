import 'package:WE/Screens/ProfileDrawer/training_set/model/training_survey.dart';
import 'package:flutter/material.dart';

class SurveyResult extends StatefulWidget {
  const SurveyResult({Key key,this.userAnswer,this.allSurvey,this.videoId}) : super(key: key);
  final List<TrainingSurvey> allSurvey;
  final Map<int,int> userAnswer;
  final String videoId;

  @override
  _SurveyResultState createState() => _SurveyResultState();
}

class _SurveyResultState extends State<SurveyResult> {
  int correctCount;
  int incorrectCount;
  int getCorrectCount(){
    var count = 0;
    widget.userAnswer.entries.forEach((element) {
      if(widget.allSurvey[element.key].correctAnswerIndex == element.value){
        count++;
      }
    });
    return count;
  }
  @override
  void initState() {
    super.initState();
    correctCount = getCorrectCount();
    incorrectCount = widget.allSurvey.length - correctCount;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Anket sonucunuz',style: TextStyle(fontSize: 26,color: Colors.white),),
        Divider(),
        Text('Doğru yanıt: $correctCount',style: TextStyle(fontSize: 20,color: Colors.white),),
        Text('Yanlış yanıt: $incorrectCount',style: TextStyle(fontSize: 20,color: Colors.white),),
        Text('Toplam kazanılan puan: ${correctCount*12.4}',style: TextStyle(fontSize: 20,color: Colors.white),),
        TextButton(onPressed: (){
          Navigator.pop(context,widget.videoId);
        },child: Text('Eğitim setine geri dön'),)
      ],
    );
  }
}
