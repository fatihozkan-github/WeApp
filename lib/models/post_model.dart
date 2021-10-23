// ignore_for_file: sort_constructors_first, omit_local_variable_types, prefer_final_fields

import 'dart:io';
import 'dart:typed_data';

import 'package:WE/Resources/components/social_icon.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

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
  ScreenshotController _screenshotController = ScreenshotController();
  String date = '';
  // bool _openCommentPanel = false;

  @override
  void initState() {
    String today = DateTime.now().toString().substring(0, 10);
    List holder = today.split('-');
    date = holder[2] + '.' + holder[1] + '.' + holder[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                    imageUrl: widget.logo.toString(),
                    progressIndicatorBuilder: (context, url, progress) =>
                        WESpinKit(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // subtitle: Text(widget.time),
                subtitle: Text(date),
              ),
              CachedNetworkImage(
                imageUrl: widget.asset.toString(),
                progressIndicatorBuilder: (context, url, progress) =>
                    WESpinKit(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fitHeight,
                height: 350,
              ),
              // Divider(),
              // if (_openCommentPanel)
              //   Column(
              //     children: [
              //       RoundedInputField(
              //         hintText: 'Yorum Yaz',
              //         icon: null,
              //         maxLines: null,
              //         textInputAction: TextInputAction.newline,
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// TODO: Fix iOS crash..
            SocialIcon(
                iconSrc: "assets/Icons/instagram2.png",
                press: () async {
                  if (Platform.isAndroid) {
                    await _screenshotController
                        .capture(delay: const Duration(milliseconds: 10))
                        .then((Uint8List image) async {
                      if (image != null) {
                        print(image);
                        final directory =
                            await getApplicationDocumentsDirectory();
                        print(directory);
                        final imagePath =
                            await File('${directory.path}/image.png').create();
                        print(imagePath);
                        await imagePath.writeAsBytes(image);
                        print(imagePath.path);
                        await SocialShare.shareInstagramStory(imagePath.path)
                            .whenComplete(() => print('share'));
                      }
                    });
                  }
                }),
            Text('Paylaş'),
            // GestureDetector(
            //   onTap: () async {
            //     await _screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List image) async {
            //       if (image != null) {
            //         final directory = await getApplicationDocumentsDirectory();
            //         final imagePath = await File('${directory.path}/image.png').create();
            //         await imagePath.writeAsBytes(image);
            //         await SocialShare.shareInstagramStory(imagePath.path);
            //       }
            //     });
            //     // final directory = (await getApplicationDocumentsDirectory()).path; //from path_provide package
            //     // String fileName = DateTime.now().microsecondsSinceEpoch.toString();
            //     // String path = '$directory';
            //     // print(path);
            //     // await _screenshotController.captureAndSave(
            //     //   path,
            //     //   fileName: fileName,
            //     // );
            //     // // PickedFile file = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
            //     // await SocialShare.shareInstagramStory(path + fileName);
            //   },
            //   child: Text('test'),
            // ),
            // Row(children: [
            //   Icon(Icons.share_rounded, size: 30, color: kPrimaryColor),
            //   SizedBox(width: 5),
            //   Text('Paylaş'),
            // ]),
          ],
        ),
      ],
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
