import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progettosd/schermate/appdrawer_user.dart';

// Home: permette di visualizzare e di iscriversi agli eventi
// disponibili e di visualizzarne i dettagli
class Home extends StatefulWidget {
  // *** Dichiarazione variabili ***
  String email;

  Home(this.email, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState(email);
}

// Definizione homepage
class _HomeState extends State<Home> {
  // *** Dichiarazione variabili ***
  String email;
  final db = FirebaseFirestore.instance;
  _HomeState(this.email);

  // Widget per la visualizzazione del singolo evento
  Card buildItem(DocumentSnapshot doc) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(
        // Visualizzazione dettagli evento
        onTap: () async {
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DettagliEvento(doc.get('NomeEvento'), doc.get('Luogo'))));*/
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "${doc.get('NomeEvento')}",
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 3),
                    const Text(
                      "Orario: ",
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${doc.get('Orario')}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 3),
                    const Text(
                      "Luogo: ",
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${doc.get('Luogo')}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Pulsante di iscrizione all'evento
                GestureDetector(
                  onTap: () => {
                    aggiornaDati(doc),
                    showDialog(
                      context: context,
                      // Visualizzazione messaggio di avvenuta iscrizione
                      // e visualizzazione codice personale
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        content: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            SizedBox(
                              height: 220,
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                child: Column(
                                  children: const [
                                    Text(
                                      "Iscrizione effettuata!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      "Vai nelle tue iscrizioni per visualizzare il tuo codice personale! 🥳",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: -60,
                              child: CircleAvatar(
                                backgroundColor: Colors.purple[700],
                                radius: 60,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              height: 50,
                              margin:
                              const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.purple[900]),
                              child: const Center(
                                child: Text(
                                  "Chiudi",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.purple[900]),
                    child: const Center(
                      child: Text(
                        "Iscriviti",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget di costruzione della schermata di homepage
  @override
  Widget build(BuildContext context) {
    // Impedisco di tornare alla schermata precedente
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Center(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Eventi',
                  style: TextStyle(fontSize: 50, color: Colors.white)),
              backgroundColor: Colors.purple[700],
            ),
            drawer: AppDrawerUser(email),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.purple[500]!,
                    Colors.purple[400]!,
                    Colors.purple[200]!,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.purple[900]!,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                              padding: const EdgeInsets.all(8),
                              children: <Widget>[
                                Column(
                                  children: [
                                    // Visualizzazione eventi
                                    StreamBuilder<QuerySnapshot>(
                                      stream:
                                      db.collection('Eventi').snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                            children: snapshot.data!.docs
                                                .map((doc) => buildItem(doc))
                                                .toList(),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Aggiornamento database con inserimento dell'evento nelle iscrizioni
  // dell'utente e dei dati dell'utente negli iscritti dell'evento
  void aggiornaDati(DocumentSnapshot doc) async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('Utenti')
        .where('Email', isEqualTo: email)
        .get();

    QueryDocumentSnapshot documentSnap = querySnap.docs[0];

    DocumentReference docRef = documentSnap.reference;



    // Inserimento dell'evento nelle iscrizioni dell'utente
    await db.collection('Eventi').doc(doc.id).update({
      'Iscritti': FieldValue.arrayUnion([
        {'Nome': '${documentSnap.get('Nome')}'}
      ])
    });

    // Inserimento dati utente negli iscritti dell'evento
    await docRef.update({
      'Eventi': FieldValue.arrayUnion([
        {'Evento': '${doc.get('NomeEvento')}'}
      ])
    });
  }
}
