import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StoresManager extends ChangeNotifier {

  StoresManager(){
    _loadStoreList();
  }

  final Firestore firestore = Firestore.instance;

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').getDocuments();

    print(snapshot.documents.first.data);

    notifyListeners();
  }

}