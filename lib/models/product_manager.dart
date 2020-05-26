import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/product.dart';

class ProductManager extends ChangeNotifier{

  ProductManager(){
    _loadAllProducts();
  }
  
  final Firestore firestore = Firestore.instance;

  List<Product> allProducts = [];
  
  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
      await firestore.collection('products').getDocuments();

    allProducts = snapProducts.documents.map(
            (d) => Product.fromDocument(d)).toList();

    notifyListeners();
  }

}