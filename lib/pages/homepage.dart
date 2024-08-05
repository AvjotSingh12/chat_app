  import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    body:  Center(
      child: ElevatedButton(
          onPressed:(){
            Navigator.pushNamed(context, '/loginpage');},
          child: const Text("start")),

    ),





    );
  }
}
