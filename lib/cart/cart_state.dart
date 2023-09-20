

import 'package:streams_demo/home/article.dart';

sealed class CartState {}

class CartStateInitial extends CartState {}

class CartStateAddedToCart extends CartState {}

class CartStateRemovedFromCart extends CartState {}

class CartStateCartItems extends CartState {
  final List<Article> cartItems;
  CartStateCartItems({required this.cartItems});
}

class CartStateError extends CartState {
  final String errorMessage;
  CartStateError({required this.errorMessage});
}
