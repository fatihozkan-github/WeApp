import 'package:flutter/material.dart';
import 'package:WE/Services/ChatService/conversation_list.dart';
import 'package:WE/models/chat_user_model.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        name: "Elon Musk",
        messageText: "Awesome Setup",
        time: "Now",
        imageURL: "assets/Images/People/elonMusk.png"),
    ChatUsers(
        name: "Larry Page",
        messageText: "Nice algorithm bro",
        time: "Yesterday",
        imageURL: "assets/Images/People/larryPage.png"),
    ChatUsers(
        name: "Mark Zuckerberg",
        messageText: "Farmville was awesome",
        time: "31 Mar",
        imageURL: "assets/Images/People/markZuckerberg.png"),
    ChatUsers(
        name: "Safra Catz",
        messageText: "OK. See you at 9 pm",
        time: "28 Mar",
        imageURL: "assets/Images/People/safraCatz.png"),
    ChatUsers(
        name: "Sundar Pichai",
        messageText: "Yeah Pixel 5 is better",
        time: "28 Mar",
        imageURL: "assets/Images/People/sundarPichai.png"),
    ChatUsers(
        name: "Aysu Keçeci",
        messageText: "I recycled 700 g today",
        time: "26 Mar",
        imageURL: "assets/Images/People/aysu.png"),
    ChatUsers(
        name: "Oprah Winfrey",
        messageText: "Hahahahahah",
        time: "18 Feb",
        imageURL: "assets/Images/People/oprah.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepOrange,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Add New",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
        title: Text(
          "Conversations",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
