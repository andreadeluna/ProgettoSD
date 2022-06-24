import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progettosd/modelli/user.dart';
import 'package:progettosd/schermate/home.dart';
import 'package:progettosd/schermate/pagina_iniziale.dart';
import 'package:progettosd/schermate/pannello_admin.dart';
import 'package:progettosd/servizi/autenticazione.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  // *** Dichiarazione variabili ***
  int checkUser = 1;

  // Definizione wrapper
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Autenticazione>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        // Se l'utente è connesso
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const PaginaIniziale();
          } else {
            FirebaseFirestore.instance
                .collection('Utenti')
                .where('Email', isEqualTo: user.email)
                .get()
                .then(
              (docs) {
                // Se l'utente è di tipo admin
                if (docs.docs[0].get('TipoUtente') == 'Admin') {
                  // Apre il pannello di gestione
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PannelloAdmin(user.email.toString())));
                } else {
                  // Apre la homepage
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home()));
                }
              },
            );
            // Gestione schermata
            return checkUser == 0
                // ? PannelloAdmin(user.email.toString())
                ? Scaffold(
                  body: Text('Prova'),
                  )
                : Scaffold(
                    backgroundColor: Colors.deepOrange[700],
                    body: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
          }
        } else {
          // Schermata di caricamento
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
