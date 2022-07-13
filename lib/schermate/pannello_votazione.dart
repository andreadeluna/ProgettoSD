import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progettosd/schermate/appdrawer_admin.dart';
import 'package:progettosd/servizi/funzioni.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

// Pannello admin: permette di visualizzare gli eventi creati, visualizzarne
// i relativi iscritti, eliminarli e crearne di nuovi
class PannelloVotazione extends StatefulWidget {
  // *** Dichiarazione variabili ***
  String email;
  final Web3Client ethClient;
  final String electionName;

  PannelloVotazione(this.email,
      {Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  _PannelloVotazioneState createState() => _PannelloVotazioneState(email, ethClient);
}

// Definizione pannello admin
class _PannelloVotazioneState extends State<PannelloVotazione> {
  // *** Dichiarazione variabili ***
  late String id;
  String email;
  final db = FirebaseFirestore.instance;
  List<Widget> textWidgetList = <Widget>[];
  final Web3Client ethClient;

  _PannelloVotazioneState(this.email, this.ethClient);

  // Widget di costruzione della schermata del pannello admin
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
                color: Colors.orange,
              ),
            ),
          ),
        ),
        home: Center(
          child: Scaffold(
            drawer: AppDrawerAdmin(email),
            appBar: AppBar(
              title: const Text('Votazione',
                  style: TextStyle(fontSize: 40, color: Colors.white)),
              backgroundColor: Colors.deepOrange[700],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.deepOrange[500]!,
                    Colors.deepOrange[400]!,
                    Colors.deepOrange[200]!,
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
                            color: Colors.deepOrange[900]!,
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
                          child: RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView(
                              padding: const EdgeInsets.all(8),
                              children: <Widget>[
                                SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    'Candidati',
                                    style: TextStyle(
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                FutureBuilder<List>(
                                  future: getCandidatesNum(widget.ethClient),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          for (int i = 0;
                                          i < snapshot.data![0].toInt();
                                          i++)
                                            FutureBuilder<List>(
                                                future: candidateInfo(
                                                    i, widget.ethClient),
                                                builder:
                                                    (context, candidatesnapshot) {
                                                  if (candidatesnapshot
                                                      .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  } else if(snapshot.data![0].toInt() == 0){
                                                    return Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                10),
                                                            child: Text(
                                                              'Non sono presenti candidati 😢',
                                                              style: TextStyle(
                                                                  fontSize: 21),
                                                              textAlign: TextAlign
                                                                  .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  else {
                                                    return Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                      color: Colors.red,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(0),
                                                        child: Container(
                                                          padding: const EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                            color: Colors.orange[50],
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
                                                                candidatesnapshot.data![0][0].toString(),
                                                                style: const TextStyle(
                                                                    fontSize: 30, fontWeight: FontWeight.bold),
                                                              ),
                                                              const SizedBox(height: 12),
                                                              Column(
                                                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            "Partito: ",
                                                                            style: TextStyle(
                                                                                fontSize: 24, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                candidatesnapshot.data![0][1].toString(),
                                                                                style: const TextStyle(fontSize: 20),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 12),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                children: [
                                                                  const Text(
                                                                    "Descrizione: ",
                                                                    style:
                                                                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    candidatesnapshot.data![0][2].toString(),
                                                                    textAlign: TextAlign.justify,
                                                                    style: const TextStyle(fontSize: 20),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 12),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context: context,
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
                                                                              height: 150,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.fromLTRB(
                                                                                    10, 70, 10, 10),
                                                                                child: Column(
                                                                                  children: const [
                                                                                    Text(
                                                                                      "Attenzione",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 23),
                                                                                    ),
                                                                                    SizedBox(height: 5),
                                                                                    Text(
                                                                                      "Confermi il voto?",
                                                                                      style: TextStyle(fontSize: 18),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: -60,
                                                                              child: CircleAvatar(
                                                                                backgroundColor: Colors.deepOrange[700],
                                                                                radius: 60,
                                                                                child: const Icon(
                                                                                  Icons.how_to_vote,
                                                                                  color: Colors.white,
                                                                                  size: 50,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                            child: const Text('No',
                                                                                style: TextStyle(
                                                                                    fontSize: 20,
                                                                                    color: Colors.orangeAccent)),
                                                                            onPressed: () {
                                                                              Navigator.pop(context, false);
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            child: const Text('Si',
                                                                                style: TextStyle(
                                                                                    fontSize: 20,
                                                                                    color: Colors.orangeAccent)),
                                                                            onPressed: () async {

                                                                              try{
                                                                                await vote(i, widget.ethClient);

                                                                                Navigator.pop(context, false);

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
                                                                                                  "Voto confermato!",
                                                                                                  style: TextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      fontSize: 23),
                                                                                                ),
                                                                                                SizedBox(height: 30),
                                                                                                Text(
                                                                                                  "Il tuo voto è stato acquisito con successo! 🥳",
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
                                                                                            backgroundColor: Colors.deepOrange[700],
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
                                                                                              color: Colors.deepOrange[900]),
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
                                                                                );

                                                                                // Toast di avvenuta eliminazione
                                                                                Fluttertoast.showToast(
                                                                                  msg: "Voto confermato",
                                                                                  toastLength: Toast.LENGTH_LONG,
                                                                                  gravity: ToastGravity.BOTTOM,
                                                                                  timeInSecForIosWeb: 1,
                                                                                  backgroundColor: Colors.blueGrey,
                                                                                  textColor: Colors.white,
                                                                                  fontSize: 16.0,
                                                                                );
                                                                              }on RPCError catch(e){

                                                                                print(e);

                                                                                Navigator.pop(context, false);

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
                                                                                                  "Hai già votato!",
                                                                                                  style: TextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      fontSize: 23),
                                                                                                ),
                                                                                                SizedBox(height: 30),
                                                                                                Text(
                                                                                                  "Non è stato possibile acquisire il voto ☹️",
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
                                                                                            backgroundColor: Colors.deepOrange[700],
                                                                                            radius: 60,
                                                                                            child: const Icon(
                                                                                              Icons.error,
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
                                                                                              color: Colors.deepOrange[900]),
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
                                                                                );

                                                                                // Toast di avvenuta eliminazione
                                                                                Fluttertoast.showToast(
                                                                                  msg: "Hai già votato!",
                                                                                  toastLength: Toast.LENGTH_LONG,
                                                                                  gravity: ToastGravity.BOTTOM,
                                                                                  timeInSecForIosWeb: 1,
                                                                                  backgroundColor: Colors.blueGrey,
                                                                                  textColor: Colors.white,
                                                                                  fontSize: 16.0,
                                                                                );
                                                                              }

                                                                            },
                                                                          ),
                                                                        ],
                                                                      ));
                                                                },
                                                                child: Container(
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      color: Colors.deepOrange[900]),
                                                                  child: const Center(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(5),
                                                                      child: Text(
                                                                        "Vota",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    );

                                                  }
                                                },
                                            ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
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

  Future _refresh() async {

    await Future.delayed(
      Duration(seconds: 0),
    );

    setState((){});
  }
}