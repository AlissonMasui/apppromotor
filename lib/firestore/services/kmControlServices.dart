import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/modelo_km_controle.dart';

class KmcontrolServices {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> adicionarListin({required KmControle kmControle}) async {
    return firestore
        .collection(uid)
        .doc(kmControle.idKmControle)
        .set(kmControle.toMap());
  }

  Future<List<KmControle>> lerKmControle() async {
    List<KmControle> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(uid).get();

    for (var doc in snapshot.docs) {
      temp.add(KmControle.fromMap(doc.data()));
    }

    return temp;
  }

  Future<void> removerKmControle({required String kmControleId}) async {
    return firestore.collection(uid).doc(kmControleId).delete();
  }
}
