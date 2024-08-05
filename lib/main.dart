import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/pages/Chatspage.dart';
import 'package:my_chat_app/pages/ChattingPage.dart';
import 'package:my_chat_app/pages/Loginpage.dart';
import 'package:my_chat_app/pages/Signuppage.dart';
import 'package:my_chat_app/pages/homepage.dart';
import 'package:my_chat_app/reusable_widgets/reusable_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:FirebaseOptions(
      apiKey: "AIzaSyBMEaoA_qqGp2GzSvNvBPBGzHCAsXDAM0o",
      appId: "1:966661780940:android:a3aa0cea54c9620ee91969",
      messagingSenderId: "966661780940",
      projectId: "chat-app-99719")

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: colorchanger("#EDF4F2"), // Set the background color here
      ),
      home: const Loginpage(),
      routes: {
        '/loginpage': (context) => const Loginpage(),
        '/chatpage': (context) => const Chatspage(),
        '/signuppage': (context) => const SignupPage(),

        // Corrected route name
      },
    );
  }
}
