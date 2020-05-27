import 'package:lojavirtual/models/product.dart';

class CartProduct {

  CartProduct.fromProduct(this.product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  String productId;
  int quantity;
  String size;

  Product product;

}