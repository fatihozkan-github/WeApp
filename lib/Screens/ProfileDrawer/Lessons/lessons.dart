import 'package:WE/Resources/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Eğitimler",
          style: TextStyle(fontFamily: "Panthera", fontSize: 24),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            EntryItem(data[index]),
        itemCount: data.length,
      ),
    );
  }
}

class Entry {
  const Entry(this.title, this.videoAPI, [this.children = const <Entry>[]]);

  final String title;
  final String videoAPI;
  final List<Entry> children;
}

const List<Entry> data = <Entry>[
  Entry(
    'Eğitim 1',
    null,
    <Entry>[
      Entry('Plastik nedir?', "ml5uefGgkaA"),
      Entry('Geri dönüşüm', "KJpkjHGiI5A"),
      Entry('Plastiğin geri dönüşümü', "KJpkjHGiI5A"),
      Entry('Geri kazanım', "KJpkjHGiI5A"),
      Entry('Geri dönüştürülebilenler', "KJpkjHGiI5A"),
    ],
  ),
];

class EntryItem extends StatelessWidget {
  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
          onTap: () {
            launchUrl("https://www.youtube.com/watch?v=" + root.videoAPI);
          },
          trailing: Icon(
            Icons.play_arrow_rounded,
            size: 40,
          ),
          title: Text(
            root.title,
            style: TextStyle(color: Colors.white),
          ));
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      collapsedIconColor: kPrimaryColor,
      tilePadding: EdgeInsets.all(8),
      iconColor: Colors.white,
      title: Text(
        root.title,
        style: TextStyle(color: kPrimaryColor),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
