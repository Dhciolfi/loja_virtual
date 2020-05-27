import 'package:cloud_firestore/cloud_firestore.dart';

class Section {

  Section.fromDocument(DocumentSnapshot document){
    name = document.data['name'] as String;
    type = document.data['type'] as String;
  }

  String name;
  String type;

}