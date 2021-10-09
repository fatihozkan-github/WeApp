import 'package:WE/Screens/ProfileDrawer/training_set/model/training_survey.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/service/training_set_service.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/widget/radio_type_survey.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/widget/survey_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SurveyPage extends StatefulWidget {
  const SurveyPage({Key key,this.youtubeId}) : super(key: key);
  final String youtubeId;

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  var currentQuestionIndex = 0;
  var userCurrentAnswer = -1;
  var userAnswer = <int,int>{};
  var pageController = PageController();
  var showResult = false;
  var isLoading = true;
  var surveys =<TrainingSurvey>[];
  
  
  
  @override
  void initState() {
    super.initState();
    getSurvey();

  }
  Future<void> getSurvey() async{
    surveys = await TrainingSetService().getTrainingSurvey(widget.youtubeId);
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Anket Sayfası'),
      ),
      body: isLoading? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: showResult ? SurveyResult(allSurvey: surveys,userAnswer: userAnswer,videoId: widget.youtubeId,) : Column(
          children: [
            Text('Soru ${currentQuestionIndex+1} \\ ${surveys.length}',style: TextStyle(fontSize: 26,color: Colors.white),),
            SizedBox(height: 16,),
            Expanded(
              child: PageView(

                controller: pageController,
                children: [
                  for(int i = 0 ;i < surveys.length;i++)
                  RadioTypeSurvey(
                    survey: surveys[i],
                    selectedAnswer: (a){
                      setState(() {
                        userCurrentAnswer = a;
                      });

                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if(currentQuestionIndex != 0)
                  TextButton.icon(onPressed: (){
                    userAnswer[currentQuestionIndex] = userCurrentAnswer;
                    currentQuestionIndex -= 1;
                    setState(() {
                    });
                    pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);

                  }, icon: Icon(Icons.arrow_back_ios), label: Text('Geri')),
                if(userAnswer.keys.contains(currentQuestionIndex) || userCurrentAnswer != -1)

                  TextButton.icon(onPressed: (){

                    if(currentQuestionIndex == surveys.length-1){
                      showResult = true;
                      userAnswer[currentQuestionIndex] = userCurrentAnswer;
                      TrainingSetService().updateTrainingHistorySurvey(widget.youtubeId);
                      setState(() {
                      });

                    }else{
                      userAnswer[currentQuestionIndex] = userCurrentAnswer;
                      currentQuestionIndex += 1;
                      userCurrentAnswer = -1;
                      setState(() {
                      });
                      pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                    }


                  }, icon: RotatedBox(
                      quarterTurns: 2,
                      child: Icon(Icons.arrow_back_ios)), label: Text('${currentQuestionIndex == surveys.length-1 ? 'Bitir' : 'İleri'}')),


              ],
            )
          ],
        ),
      ),
    );
  }
}
