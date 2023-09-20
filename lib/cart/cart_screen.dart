import 'package:flutter/material.dart';
import 'package:streams_demo/cart/cart_controller.dart';
import 'package:streams_demo/cart/cart_state.dart';
import 'package:streams_demo/home/article.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.controller});

  final CartController controller;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.getCartItems();
    widget.controller.cartState.listen((cartState) {
      // Handle cart state changes here
      debugPrint('Cart State: $cartState');
    });
  }

  @override
  void dispose() {
    super.dispose();
     widget.controller.cartState.drain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Screen'),
      ),
      body: StreamBuilder(
        stream: widget.controller.cartState,
        builder: (context, snapshot) {
          debugPrint('snapshotState: ${widget.controller.cartState.first}');
          if (snapshot.hasData) {
            final cartState = snapshot.data as CartState;
            if (cartState is CartStateCartItems) {
              debugPrint('lenght: ${cartState.cartItems.length}');
              return _buildCartList(cartState.cartItems);
            }
            return Container();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No item found in the cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCartList(List<Article> cartItems) {
    return ListView.separated(
      itemBuilder: ((context, index) => _buildCartItem(cartItems[index])),
      separatorBuilder: (_, __) => const SizedBox(
        height: 8,
      ),
      itemCount: cartItems.length,
    );
  }

  Widget _buildCartItem(Article cartItem) {
    return Text(cartItem.body);
  }
}
