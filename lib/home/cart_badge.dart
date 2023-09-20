import 'package:flutter/material.dart';
import 'package:streams_demo/cart/cart_controller.dart';
import 'package:streams_demo/cart/cart_screen.dart';
import 'package:streams_demo/cart/cart_state.dart';

class CartBadge extends StatefulWidget {
  const CartBadge({super.key, required this.cartController});

  final CartController cartController;

  @override
  State<CartBadge> createState() => _CartBadgeState();
}

class _CartBadgeState extends State<CartBadge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CartScreen(
                controller: widget.cartController,
              ),
            ),
          ),
          icon: const Icon(Icons.badge),
        ),
        Positioned(
          top: 2,
          right: 6,
          child: StreamBuilder(
            stream: widget.cartController.cartState,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cartState = snapshot.data as CartState;
                if ((cartState is CartStateAddedToCart) ||
                    (cartState is CartStateCartItems)) {
                  return Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      (cartState as CartStateCartItems)
                          .cartItems
                          .length
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  );
                } else if ((cartState is CartStateRemovedFromCart) ||
                    (cartState is CartStateCartItems)) {
                  return Text((cartState as CartStateCartItems)
                      .cartItems
                      .length
                      .toString());
                }
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}
