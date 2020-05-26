import 'package:cloud_firestore/cloud_firestore.dart';

class ProductManager {

  ProductManager(){
    _loadAllProducts();
  }
  
  final Firestore firestore = Firestore.instance;
  
  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
      await firestore.collection('products').getDocuments();

    for(DocumentSnapshot doc in snapProducts.documents){
      print(doc.data);
    }
  }

}