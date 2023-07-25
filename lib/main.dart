import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:groovify/screens/homescreen.dart';
import 'package:groovify/screens/widgets/playlistwidget.dart';
import 'package:just_audio/just_audio.dart';
import 'screens/loginscreen.dart';
import 'screens/registerscreen.dart';

import 'screens/playingscreen.dart';
import './screens/demandscreen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCcLygRuCkh2uugbt3fMXC8dAxkT9QAsho",
        appId: "1:620134107676:android:f8ff24a5c633f30ddf2dd9",
        messagingSenderId: "620134107676",
        projectId: "groovify-8e551"),
  );
  runApp(groovifymain());
}

class groovifymain extends StatefulWidget {
  const groovifymain({super.key});

  @override
  State<groovifymain> createState() => _groovifymainState();
}

class _groovifymainState extends State<groovifymain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: loginScreen.id,
      routes: {
        loginScreen.id: (context) => loginScreen(),
        registerScreen.id: (context) => registerScreen(),
        homeScreen.id: (context) => homeScreen(),
        PlayingScreen.id: (context) => PlayingScreen(audioPlayer:AudioPlayer(),songlength: Duration(seconds: 1000),name: 'SongName',),
        demandscreen.id: (context) => demandscreen(
              genre: 'f',
            ),
      },
    );
  }
}
