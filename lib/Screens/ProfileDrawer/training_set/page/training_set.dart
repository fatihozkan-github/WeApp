import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/model/training_survey.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/model/training_video.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/page/survey_page.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/service/training_set_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/training_video_history.dart';
import '../util/show_confirmation_dialog.dart';

class TrainingSet extends StatefulWidget {
  const TrainingSet({Key key}) : super(key: key);

  @override
  _TrainingSetState createState() => _TrainingSetState();
}

class _TrainingSetState extends State<TrainingSet> {
  bool isLoading;
  var allVideo = <TrainingVideo>[];
  var userVideoHistory = <TrainingVideoHistory>[];
  var selectedVideoIndex = 0;
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    isLoading = true;
    setState(() {});

    getVideos().then((value) async {
      _controller = YoutubePlayerController(
        initialVideoId: '${allVideo.first.youtubeId}',
        flags: YoutubePlayerFlags(
          autoPlay: false,
          hideControls: false,
          mute: true,
        ),
      );
      userVideoHistory = await TrainingSetService().getUserTrainingVideoHistory();
      isLoading = false;
      setState(() {});
    });
  }

  Future<void> getVideos() async {
    allVideo = await TrainingSetService().getTrainingVideo();
  }

  bool userCompletedVideoBefore() {
    if (!userVideoHistory.map((e) => e.videoId).contains(allVideo[selectedVideoIndex].youtubeId)) {
      return false;
    }
    return true;
  }

  bool userCompletedSurveyBefore() {
    var currentVideoHistory =
        userVideoHistory.where((element) => element.videoId == allVideo[selectedVideoIndex].youtubeId).toList();
    if (currentVideoHistory.isEmpty) {
      return false;
    } else {
      if (currentVideoHistory.first.completedSurvey) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eğitim Seti'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                YoutubePlayer(
                  controller: _controller,
                  bottomActions: [],
                  onEnded: (a) async {
                    if (!userCompletedVideoBefore()) {
                      var res = await TrainingSetService().saveTrainingVideoHistory(allVideo[selectedVideoIndex].youtubeId);
                      userVideoHistory.add(res);
                      setState(() {});
                    }
                    if (allVideo[selectedVideoIndex].hasSurvey && !userCompletedSurveyBefore()) {
                      var result = await showConfirmDialog(
                          'Video ile ilgili anket tamamlayıp daha fazla puan kazanmak ister misin?', context, 'Evet');
                      if (result != null && result) {
                        var survey = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SurveyPage(
                                      youtubeId: allVideo[selectedVideoIndex].youtubeId,
                                    ))).then((value) {
                          print('sa');
                          initialize();
                        });
                      }
                    }
                  },
                ),
                Expanded(
                    child: ListView.separated(
                        itemCount: allVideo.length,
                        separatorBuilder: (c, i) {
                          return Divider(
                            color: Colors.grey,
                          );
                        },
                        itemBuilder: (c, i) {
                          var video = allVideo[i];

                          return ListTile(
                            onTap: () {
                              selectedVideoIndex = i;
                              setState(() {
                                _controller.load(video.youtubeId);
                              });
                            },
                            leading: Text(
                              '${i + 1}',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            title: Text(
                              video.title,
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              '${video.durationMinutes} dk ',
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Text(
                              '${userVideoHistory.where((element) => element.videoId == video.youtubeId && element.completedVideo).isNotEmpty ? 'İzlendi' : 'izlenmedi'}',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        })),
              ],
            ),
    );
  }
}
