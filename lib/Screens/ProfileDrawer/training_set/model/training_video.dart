class TrainingVideo{
  const TrainingVideo({this.youtubeId, this.title, this.durationMinutes,this.hasSurvey});

  factory TrainingVideo.fromJson(Map<String,dynamic> json){
    return TrainingVideo(
      youtubeId: json['youtubeId'],
      title: json['title'],
      durationMinutes: json['durationMinutes'],
      hasSurvey: json['hasSurvey'],
    );
  }

  final String youtubeId;
  final String title;
  final int durationMinutes;
  final bool hasSurvey;

  Map<String,dynamic> toMap()=>{
    'youtubeId':youtubeId,
    'hasSurvey':hasSurvey,
    'title':title,
    'durationMinutes':durationMinutes
  };
}