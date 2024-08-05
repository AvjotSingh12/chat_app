import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/pages/ChattingPage.dart';
import 'package:my_chat_app/reusable_widgets/reusable_widget.dart';

class Chatspage extends StatelessWidget {
  const Chatspage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Handle case where user might be null
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No user logged in'),
        ),
      );
    }

    String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(
          color: Colors.white

        ),),
        backgroundColor: colorchanger("#2A3132"), // Ensure the color is set correctly
        centerTitle: true,

        leading:  IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // Add the arrow icon in white
            onPressed: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // Filter out the current user's document
              var userDocs = snapshot.data?.docs
                  .where((doc) => doc["userId"] != userId)
                  .toList();

              return ListView.builder(
                itemCount: userDocs?.length ?? 0,
                itemBuilder: (context, index) {
                  var userDoc = userDocs?[index];
                  if (userDoc == null) {
                    return SizedBox.shrink();
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text(
                      userDoc["Name"] ?? "No Name",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      userDoc["Username"] ?? "No Username",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChattingPage(
                            name: userDoc["Name"],
                            recieverId: userDoc["userId"],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return const Center(child: Text("No data available"));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
