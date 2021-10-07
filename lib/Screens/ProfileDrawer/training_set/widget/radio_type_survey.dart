import 'package:WE/Screens/ProfileDrawer/training_set/model/training_survey.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioTypeSurvey extends StatefulWidget {
  const RadioTypeSurvey({Key key,this.survey,this.selectedAnswer}) : super(key: key);
  final TrainingSurvey survey;
  final Function(int) selectedAnswer;

  @override
  _RadioTypeSurveyState createState() => _RadioTypeSurveyState();
}

class _RadioTypeSurveyState extends State<RadioTypeSurvey>   with AutomaticKeepAliveClientMixin{
  int index = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.survey.question}',style: TextStyle(fontSize: 20,color: Colors.white),),
        for(int i  = 0 ; i <widget.survey.answers.length ;i++)
          Theme(
            data: ThemeData(
                unselectedWidgetColor: Colors.white
            ),
            child: RadioListTile(value: i,
              activeColor: Colors.white,
              groupValue: index, onChanged: (a){
                widget.selectedAnswer(a);
                setState(() {
                  index = a;
                });
              },title: Text('${widget.survey.answers[i]}',style: TextStyle(color: Colors.white),),),
          )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
