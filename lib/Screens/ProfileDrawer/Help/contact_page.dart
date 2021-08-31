import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Support",
          style: TextStyle(fontFamily: "Panthera", fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SizedBox(height: size.height * 0.01),
            Text(
              "We are here to make the most of all the features of WE.",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              "Help Center",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                "For general questions and video tutorials, you can browse our Help center.",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: size.height * 0.05),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: size.height * 0.05),
            Text("Contact us", style: TextStyle(color: Colors.white)),
            SizedBox(height: size.height * 0.02),
            Text(
                "If you still have any questions, feel free to send us a message.",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: size.height * 0.05),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: size.height * 0.05),
            Text("Terms and Privacy Policy",
                style: TextStyle(color: Colors.white)),
            SizedBox(height: size.height * 0.02),
            Text("Here you can read the Terms and Privacy Policy.",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
