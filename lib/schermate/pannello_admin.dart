import 'package:flutter/material.dart';
import 'package:progettosd/schermate/pagina_iniziale.dart';
import 'package:progettosd/servizi/autenticazione.dart';
import 'package:provider/provider.dart';

class PannelloAdmin extends StatefulWidget {
  const PannelloAdmin({Key? key}) : super(key: key);

  @override
  State<PannelloAdmin> createState() => _HomeState();
}

class _HomeState extends State<PannelloAdmin> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Autenticazione>(context);
    return Scaffold(
      body: Column(
        children: [
          Text('Admin Registrato!'),
          ElevatedButton(
              onPressed: () async {
                await authService.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaginaIniziale()));
              },
              child: Text('Logout'))
        ],
      ),
    );
  }
}
