import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splashscreen.dart';

// Punto di inizio dell'applicazione
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Inizializzazione Firebase
  try{
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCRqNRhr9DUGlYKO_JjrYO5BVW3pe1lCEs",
        appId: "1:443473479670:web:71bbc28a798d20832069d7",
        messagingSenderId: "443473479670",
        projectId: "letsvote-2407c",
      ),
    );
  }
  catch(e){
    Scaffold(
      body: Container(
        child: Text('$e'),
      ),
    );
  }

  // Inizializzazione schermata iniziale dell'app
  runApp(SplashScreen());

}