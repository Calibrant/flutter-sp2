import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_sp2/googlemap_screen.dart';
import 'package:get/get.dart';
import 'const.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    bool boolen;
    return FirebaseFirestore.instance
        .collection(COLLECTION)
        .where(COMPANY_SERVICE, isGreaterThanOrEqualTo: queryString)
        .limit(5)
        .get();
  }
}
