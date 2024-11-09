import '../telas/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '../telas/login.dart';
import 'package:flutter/material.dart';

void main ()async {
  WidgetsFlutterBinding.ensureInitialized();
  
 
   await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
 runApp(const AppPromotor());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.collection("Só para testar").doc("Estou testando").set({
    "funcionou?": true,
    });
}

class AppPromotor extends StatelessWidget {
  const AppPromotor({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
        title: "App Promotor de Vendas",
        debugShowCheckedModeBanner: false,
         
         home: RoteadorTelas(),
      );
  }
}

class RoteadorTelas extends StatelessWidget {
  const RoteadorTelas({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return Homepage(
              user: snapshot.data!,
            );
          } else {
            return const Login();
          }
        }
      },
    );
  }
}


