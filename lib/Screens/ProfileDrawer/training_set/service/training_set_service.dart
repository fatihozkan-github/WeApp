import 'package:WE/Screens/ProfileDrawer/training_set/model/training_survey.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/model/training_video.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/model/training_video_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainingSetService {
  factory TrainingSetService() {
    return _instance ??= TrainingSetService._();
  }

  TrainingSetService._();

  static TrainingSetService _instance;

  var firebaseInstance = FirebaseFirestore.instance;

  Future<List<TrainingVideo>> getTrainingVideo() async {
    var result = await firebaseInstance.collection('trainingSet').get();
    return result.docs.map((e) => TrainingVideo.fromJson(e.data())).toList();
  }

  Future<TrainingVideoHistory> saveTrainingVideoHistory(String videoId) async {
    var data = TrainingVideoHistory(
        userId: FirebaseAuth.instance.currentUser.uid,
        completedVideo: true,
        completedSurvey: false,
        videoId: videoId);
    await firebaseInstance.collection('trainingSetHistory').add(data.toMap());
    return data;
  }

  Future<List<TrainingVideoHistory>> getUserTrainingVideoHistory() async {
    var result = await firebaseInstance
        .collection('trainingSetHistory')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    return result.docs
        .map((e) => TrainingVideoHistory.fromJson(e.data()))
        .toList();
  }

  Future<List<TrainingSurvey>> getTrainingSurvey(String youtubeId) async {
    var docId = await FirebaseFirestore.instance
        .collection('/trainingSet/')
        .where('youtubeId', isEqualTo: youtubeId)
        .get();
    var result = await FirebaseFirestore.instance
        .collection('trainingSet/${docId.docs.first.id}/survey')
        .get();
    return result.docs.map((e) => TrainingSurvey.fromJson(e.data())).toList();
  }

  Future<void> updateTrainingHistorySurvey(String youtubeId) async {
    var docId = await FirebaseFirestore.instance
        .collection('/trainingSetHistory')
        .where('videoId', isEqualTo: youtubeId)
        .get();
    var uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .doc(
            'trainingSetHistory/${docId.docs.where((element) => element.data()['userId'] == uid).first.id}')
        .update({'completedSurvey':true});
  }
}
