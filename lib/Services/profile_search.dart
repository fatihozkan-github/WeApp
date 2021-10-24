// ignore_for_file: omit_local_variable_types

import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/rounded_list_tile.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/hisprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<List<String>> items = [];

  getData() {
    getAllUsersData('');
  }

  Future<String> getAllUsersData(String query) async {
    List<String> subPeople = [];
    List<List<String>> People2 = [];

    /// collection problem.
    // var collection = FirebaseFirestore.instance.collection('allUsers');
    // var docSnapshot = await collection.doc('C9nvPCW2TwemcjSVgm04').get();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var snapShot = await users.get();
    print(snapShot.size);
    snapShot.docs.forEach((element) {
      // for (var i = 0; i < snapShot.size; i++) {
      // Map<String, dynamic> data = element.data()[localList[i]];
      subPeople.insert(0, element['name']);
      subPeople.insert(1, element['superhero']);
      subPeople.insert(2, element['avatar']);
      subPeople.insert(3, element['uid']);
      subPeople.insert(4, element['level'].toString());
      subPeople.insert(5, element['coins'].toString());
      subPeople.insert(6, element['recycled'].toString());
      subPeople.insert(7, element['superhero']);
      // }
    });
    for (var i = 0; i < subPeople.length; i += 8) {
      People2.add(subPeople.sublist(i, i + 8 > subPeople.length ? subPeople.length : i + 8));
    }
    // print(People2);
    items.addAll(People2);
    List<List<String>> firstList = [];
    firstList.addAll(People2);
    if (query.isNotEmpty) {
      List<List<String>> secondList = [];
      firstList.forEach((item) {
        if (item[0].toUpperCase().contains(query.toUpperCase())) {
          secondList.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(secondList);
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(firstList);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil Ara')),
      body: Column(
        children: <Widget>[
          RoundedInputField(
            hintText: 'Ara',
            icon: Icons.search,
            onChanged: (value) => getAllUsersData(value),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              itemBuilder: (context, index) {
                return RoundedListTile(
                  title: Text(items[index][0].toString()),
                  leading: Container(
                    width: 48,
                    height: 48,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Image(
                      image: items[index][2] != null && items[index][2] != ''
                          ? NetworkImage(items[index][2].toString())
                          : AssetImage("assets/Icons/user.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HisProfile(uid: items[index][3]))),
                );
                // return ListTile(
                //   contentPadding: EdgeInsets.only(left: 15, top: 5),
                //   leading: items[index][2] == null || items[index][2].toString().trim() == ''
                //       ? Image.asset('assets/Icons/user.png')
                //       : Image.network(items[index][2]),
                //   title: Text('${items[index][0]}', style: TextStyle(color: Colors.black, fontSize: 18)),
                //   subtitle: Text(items[index][1] ?? ''),
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => HisProfile(uid: items[index][3])));
                //   },
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// List<List<String>> People = [
//   ['Aysu Keçeci', 'Wonder woman', 'assets/Images/People/aysu.png', 'usixnrYluAelbadO68ABJz5AJ3u2'],
//   ['Larry Page', 'X-man', 'assets/Images/People/larryPage.png', 'usixnrYluAelbadO68ABJz5AJ3u2']
// ];
///
// if (users..exists) {
//   Map<String, dynamic> data = docSnapshot.data();
//   List localList = data.keys.toList();
//   localList.sort();
//   for (var i = 0; i < localList.length; i++) {
//     Map<String, dynamic> data = docSnapshot.data()[localList[i]];
//     subPeople.insert(0, data['name']);
//     subPeople.insert(1, data['superhero']);
//     subPeople.insert(2, data['avatar']);
//     subPeople.insert(3, data['uid']);
//     subPeople.insert(4, data['level'].toString());
//     subPeople.insert(5, data['coins'].toString());
//     subPeople.insert(6, data['recycled'].toString());
//     subPeople.insert(7, data['superhero']);
//     print(data['avatar']);
//   }
// }
///
// void filterSearchResults(String query) {
//   List<List<String>> firstList = List<List<String>>();
//   firstList.addAll(People);
//   if (query.isNotEmpty) {
//     List<List<String>> secondList = List<List<String>>();
//     firstList.forEach((item) {
//       if (item[0].toUpperCase().contains(query.toUpperCase())) {
//         secondList.add(item);
//       }
//     });
//     setState(() {
//       items.clear();
//       items.addAll(secondList);
//     });
//     return;
//   } else {
//     setState(() {
//       items.clear();
//       items.addAll(firstList);
//     });
//   }
// }
///
// TextField(
//   style: TextStyle(color: Colors.black),
//   onChanged: (value) {
//     getAllUsersData(value);
//   },
//   controller: editingController,
//   decoration: InputDecoration(
//     fillColor: kPrimaryColor,
//     hoverColor: kPrimaryColor,
//     focusColor: kPrimaryColor,
//     labelText: "Ara",
//     prefixIcon: Icon(Icons.search, color: kPrimaryColor),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: kPrimaryColor),
//       borderRadius: BorderRadius.circular(25.0),
//     ),
//   ),
// ),
