import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/AllScreens/LoginScreen.dart';
import 'package:flutter_myapp/AllScreens/mainscreen.dart';
import 'package:flutter_myapp/AllScreens/registrationScreen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Rider App',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MainScreen.IdScreen,
      routes:
      {
        RegistrationScreen.IdScreen: (context) => RegistrationScreen(),
        LoginScreen.IdScreen: (context) => LoginScreen(),
        MainScreen.IdScreen: (context) => MainScreen(),
      },
      debugShowCheckedModeBanner: false,
       );
  }
}


