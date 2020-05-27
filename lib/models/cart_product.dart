import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';

class CartProduct {

  CartProduct.fromProduct(this.product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document){
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    firestore.document('products/$productId').get().then(
      (doc) => product = Product.fromDocument(doc)
    );
  }

  final Firestore firestore = Firestore.instance;

  String productId;
  int quantity;
  String size;

  Product product;

  ItemSize get itemSize {
    if(product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if(product == null) return 0;
    return itemSize?.price ?? 0;
  }

  Map<String, dynamic> toCartItemMap(){
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product){
    return product.id == productId && product.selectedSize.name == size;
  }
}