// ignore_for_file: sort_constructors_first

import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class PostModel extends StatefulWidget {
  final String name;
  final String logo;
  final String time;
  final String text;
  final String asset;

  PostModel({
    this.name,
    this.logo,
    this.time,
    this.text,
    this.asset,
  });

  @override
  State<PostModel> createState() => _PostModelState();
}

class _PostModelState extends State<PostModel> {
  bool _openCommentPanel = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CachedNetworkImage(
                imageUrl: widget.logo.toString(),
                progressIndicatorBuilder: (context, url, progress) => WESpinKit(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(widget.time),
          ),
          CachedNetworkImage(
            imageUrl: widget.asset.toString(),
            progressIndicatorBuilder: (context, url, progress) => WESpinKit(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.fitHeight,
            height: 350,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  LikeButton(
                    likeCount: 6,
                    likeBuilder: (isLiked) {
                      return Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined, size: 30, color: kPrimaryColor);
                    },
                  ),
                  SizedBox(width: 5),
                  Text('Beğen'),
                  // Text(isLiked ? 'Beğenildi' : 'Beğen'),
                ],
              ),
              GestureDetector(
                  onTap: () => setState(() => _openCommentPanel = true),
                  child: Row(children: [
                    Icon(Icons.comment_outlined, size: 30, color: kPrimaryColor),
                    SizedBox(width: 5),
                    Text('Yorum Yap')
                  ])),
              Row(children: [Icon(Icons.share_rounded, size: 30, color: kPrimaryColor), SizedBox(width: 5), Text('Paylaş')]),
            ],
          ),
          if (_openCommentPanel)
            Column(
              children: [
                RoundedInputField(
                  hintText: 'Yorum Yaz',
                  icon: null,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class Post {
  String authorName;
  String authorImageUrl;
  String timeAgo;
  String imageUrl;
  String likeCount;
  String shareCount;

  Post({
    this.authorName,
    this.authorImageUrl,
    this.timeAgo,
    this.imageUrl,
    this.likeCount,
    this.shareCount,
  });
}

final List<Post> posts = [
  Post(
      authorName: 'Alihan Soykal',
      authorImageUrl: 'assets/Images/People/alihan.png',
      timeAgo: '5 min',
      imageUrl: 'assets/Images/Feeds/eventfeed.gif',
      likeCount: "482 ",
      shareCount: "76"),
  Post(
      authorName: 'Aysu Keçeci',
      authorImageUrl: 'assets/Images/People/aysu.png',
      timeAgo: '10 min',
      imageUrl: 'assets/Images/Feeds/celebrate.gif',
      likeCount: "522 ",
      shareCount: "44"),
  Post(
      authorName: 'Larry Page',
      authorImageUrl: 'assets/Images/People/larryPage.png',
      timeAgo: '1 day',
      imageUrl: 'assets/Images/Feeds/larryfeed.gif',
      likeCount: "602",
      shareCount: "271"),
  Post(
      authorName: 'Aysu Keçeci',
      authorImageUrl: 'assets/Images/People/aysu.png',
      timeAgo: '2 weeks',
      imageUrl: 'assets/Images/Feeds/competitionfeed.png',
      likeCount: "122",
      shareCount: "18"),
  Post(
      authorName: 'Sundar Pichai',
      authorImageUrl: 'assets/Images/People/sundarPichai.png',
      timeAgo: '2 years',
      imageUrl: 'assets/Images/Feeds/friendshipfeed.gif',
      likeCount: "573 ",
      shareCount: "300"),
];
