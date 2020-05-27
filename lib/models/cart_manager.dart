import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';

class CartManager {

  List<CartProduct> items = [];

  void addToCart(Product product){
    items.add(CartProduct.fromProduct(product));
  }

}