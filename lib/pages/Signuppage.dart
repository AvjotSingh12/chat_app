import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/reusable_widgets/reusable_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: pickedImage != null
                    ? CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(pickedImage!),
                )
                    : const CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.person, size: 80),
                ),
                onTap: () {
                  showAlertBox(context);
                },
              ),
              const SizedBox(height: 20),
              reusableTextField('Enter name', Icons.person_outline, false, nameController),
              const SizedBox(height: 20),
              reusableTextField('Enter Username', Icons.person_outline, false, usernameController),
              const SizedBox(height: 20),
              reusableTextField('Enter password', Icons.person_outline, false, passwordController),
              const SizedBox(height: 30),
              signInsignupButton(context, false, () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: usernameController.text,
                  password: passwordController.text,
                )
                    .then((value) {
                  // Get the user ID
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  print('User created with ID: $userId');
                  addData(nameController.text, usernameController.text, userId);
                  Navigator.pushNamed(context, "/chatpage");
                }).catchError((error) {
                  print('Error creating user: $error');
                });
              })
            ],
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource src) async {
    try {
      final photo = await ImagePicker().pickImage(source: src);
      if (photo == null) return;

      final tempImage = File(photo.path);

      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  showAlertBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick Image From"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  addData(String name, String username, String userid) async {
    if (name.isEmpty || username.isEmpty) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Required field"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              )
            ],
          );
        },
      );
    } else {
      try {
        print('Uploading image...');
        UploadTask uploadTask = FirebaseStorage.instance.ref("profile pic").child(name).putFile(pickedImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();
        print('Image uploaded. URL: $url');

        print('Adding user data to Firestore...');
        await FirebaseFirestore.instance.collection("users").doc(name).set({
          "Name": name,
          "Username": username,
          "userId": userid,
          "profilePic": url
        });
        print('User data added to Firestore.');
      }  catch (error) {
        print('Error adding data to Firestore: $error');
      }
    }
  }
}
