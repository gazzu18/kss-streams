import 'dart:async';

import 'package:streams_demo/cart/cart_state.dart';
import 'package:streams_demo/home/article.dart';


class CartController {
  final Set<Article> cartItems = {};
  final StreamController<CartState> _cartStateController =
      StreamController.broadcast();

  CartController._();

  factory CartController() => CartController._();

  Stream<CartState> get cartState => _cartStateController.stream;

  void addToCart({required Article article}) {
    cartItems.add(article);
    _updateCartState();
  }

  void removeFromCart({required Article article}) {
    if (cartItems.contains(article)) {
      cartItems.remove(article);
      _updateCartState();
    } else {
      _cartStateController.add(CartStateError(errorMessage: 'Item not found in cart'));
    }
  }

  List<Article> getCartItems() {
    return cartItems.toList();
  }

  void _updateCartState() {
    _cartStateController.add(CartStateAddedToCart());
    _cartStateController.add(CartStateCartItems(cartItems: getCartItems()));
  }

  void dispose() {
    _cartStateController.close();
  }

  void clear() {
    _cartStateController.add(CartStateCartItems(cartItems: []));
  }
}
