import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/services/cielo_payment.dart';

enum Status { canceled, preparing, transporting, delivered }

class Order {

  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.documentID;

    items = (doc.data['items'] as List<dynamic>).map((e){
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;

    status = Status.values[doc.data['status'] as int];

    payId = doc.data['payId'] as String;
  }
  
  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef =>
    firestore.collection('orders').document(orderId);

  void updateFromDocument(DocumentSnapshot doc){
    status = Status.values[doc.data['status'] as int];
  }
  
  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData(
      {
        'items': items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address.toMap(),
        'status': status.index,
        'date': Timestamp.now(),
        'payId': payId,
      }
    );
  }

  Function() get back {
    return status.index >= Status.transporting.index ?
      (){
        status = Status.values[status.index - 1];
        firestoreRef.updateData({'status': status.index});
      } : null;
  }

  Function() get advance {
    return status.index <= Status.transporting.index ?
      (){
        status = Status.values[status.index + 1];
        firestoreRef.updateData({'status': status.index});
      } : null;
  }

  Future<void> cancel() async {
    try {
      await CieloPayment().cancel(payId);

      status = Status.canceled;
      firestoreRef.updateData({'status': status.index});
    } catch (e){
      debugPrint('Erro ao cancelar');
      return Future.error('Falha ao cancelar');
    }
  }

  String orderId;
  String payId;

  List<CartProduct> items;
  num price;

  String userId;

  Address address;

  Status status;

  Timestamp date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch(status){
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}