import 'package:construmatapp/receiver/screens/receiver_screen.dart';
import 'package:construmatapp/screens/login_page.dart';
import 'package:construmatapp/widgets/auth_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin/screens/adm_screen.dart';
import 'client/screens/solicitante_screen.dart';

class ConstruMatApp extends StatelessWidget {
  const ConstruMatApp({Key? key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'ConstruMat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => AuthCheck(
                solicitanteScreen: PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    final user = FirebaseAuth.instance.currentUser!;
                    return SolicitanteScreen(title: '', user: user);
                  },
                ),
                receiverScreen: PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                  currentUser != null
                      ? ReceiverScreen(title: '', user: currentUser)
                      : const LoginPage(),
                ),
                admScreen: PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                  const AdmScreen(title: ''),
                ),
                loginScreen: PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginPage(),
                ),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('Rota não encontrada: ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}