import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/address.dart';

class Store {

  Store.fromDocument(DocumentSnapshot doc){
    name = doc.data['name'] as String;
    image = doc.data['image'] as String;
    phone = doc.data['phone'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);

    opening = (doc.data['opening'] as Map<String, dynamic>).map((key, value) {
      final timesString = value as String;

      if(timesString != null && timesString.isNotEmpty){
        final splitted = timesString.split(RegExp(r"[:-]"));

        return MapEntry(
          key,
          {
            "from": TimeOfDay(
              hour: int.parse(splitted[0]),
              minute: int.parse(splitted[1])
            ),
            "to": TimeOfDay(
                hour: int.parse(splitted[2]),
                minute: int.parse(splitted[3])
            ),
          }
        );
      } else {
        return MapEntry(key, null);
      }
    });

    print(opening);
  }

  String name;
  String image;
  String phone;
  Address address;
  Map<String, Map> opening;

  String get addressText =>
      '${address.street}, ${address.number}${address.complement.isNotEmpty ? ' - ${address.complement}' : ''} - '
      '${address.district}, ${address.city}/${address.state}';

}