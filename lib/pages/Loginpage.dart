import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/reusable_widgets/reusable_widget.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "LOG",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    " IN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            reusableTextField("Enter Username", Icons.verified_user, false, emailcontroller),
            const SizedBox(height: 20),
            reusableTextField("Enter Password", Icons.lock_outline, true, passwordcontroller),
            signInsignupButton(context, true, () {
              FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailcontroller.text,
                  password: passwordcontroller.text).then((value) {
                Navigator.pushNamed(context, '/chatpage');
              }).onError((error, stackTrace) {
                print("Error ${error.toString()}");
              });


            }),
        signupOption(context)],
        ),
      ),
    );
  }

  Row signupOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.black26),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/signuppage');
          },
          child: const Text(
            " Sign up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
