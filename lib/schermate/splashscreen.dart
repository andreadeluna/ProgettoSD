import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progettosd/servizi/autenticazione.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // Definizione schermata iniziale
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Autenticazione>(
          create: (_) => Autenticazione(),
        ),
      ],
      child: MaterialApp(
        title: 'Progetto Sistemi Distribuiti',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
        },
      ),
    );
  }
}

// Implementazione splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Visualizzazione della splash screen per 2 secondi
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
          () {
        // Apertura schermata di autenticazione o dell'homepage
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
      },
    );
  }

  // Widget di costruzione della schermata di splash screen
  @override
  Widget build(BuildContext context) {
    // Impedisco di tornare alla schermata precedente
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        home: Scaffold(
          backgroundColor: Colors.deepOrange[700],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/icona.png', height: 200),
                const SizedBox(height: 20),
                const Text(
                  "Let's Vote!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
