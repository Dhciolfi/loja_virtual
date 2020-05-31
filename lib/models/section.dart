import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/section_item.dart';

class Section extends ChangeNotifier {

  Section({this.name, this.type, this.items}){
    items = items ?? [];
  }

  Section.fromDocument(DocumentSnapshot document){
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    items = (document.data['items'] as List).map(
      (i) => SectionItem.fromMap(i as Map<String, dynamic>)).toList();
  }

  String name;
  String type;
  List<SectionItem> items;

  String _error;
  String get error => _error;
  set error(String value){
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item){
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item){
    items.remove(item);
    notifyListeners();
  }

  bool valid(){
    if(name == null || name.isEmpty){
      error = 'Título inválido';
    } else if(items.isEmpty){
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  Section clone(){
    return Section(
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}