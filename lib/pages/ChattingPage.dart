import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widget.dart';

class ChattingPage extends StatelessWidget {
  final String name;
  final String recieverId;

  ChattingPage({required this.name, required this.recieverId, super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String senderId = user != null ? user.uid : "No user logged in";
    String chatRoomId = getChatRoomId(senderId, recieverId);
    TextEditingController messageController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title:  Text(name, style: TextStyle(
            color: Colors.white

          ),),
          backgroundColor: colorchanger("#2A3132"), // Ensure the color is set correctly


          leading:  IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // Add the arrow icon in white
            onPressed: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.white,))
              ],
          

        ),
      body:  Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(chatRoomId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No messages"));
                  }
                  var messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isSender = message['senderId'] == senderId;
                      return Align(
                        alignment:
                        isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: ChatBubble(
                          text: message['text'],
                          isSender: isSender,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              color:colorchanger("#2A3132") ,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(

                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: const TextStyle(
                              color: Colors.white
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Container(
                        decoration:  BoxDecoration(
                          color: colorchanger("#B85042"),
                          shape: BoxShape.circle
                        ),



                        child: IconButton(
                          icon:  Icon(Icons.send, color: Colors.white,),

                          onPressed: () {
                            sendMessage(chatRoomId, senderId, messageController.text);
                            messageController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

    )
    );
  }

  String getChatRoomId(String senderId, String receiverId) {
    return senderId.hashCode <= receiverId.hashCode
        ? '$senderId\_$receiverId'
        : '$receiverId\_$senderId';
  }

  void sendMessage(String chatRoomId, String senderId, String text) {
    var message = {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message);
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  ChatBubble({required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: isSender ? colorchanger("#B85042") :  colorchanger("#FFF2D7"),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: isSender ? const Radius.circular(15) : const Radius.circular(0),
          bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSender ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
