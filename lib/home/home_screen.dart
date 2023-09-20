import 'package:flutter/material.dart';
import 'package:streams_demo/cart/cart_controller.dart';
import 'package:streams_demo/cart/cart_state.dart';
import 'package:streams_demo/home/article.dart';
import 'package:streams_demo/home/cart_badge.dart';
import 'package:streams_demo/home/home_controller.dart';
import 'package:streams_demo/utils/helpers.dart';
import 'package:streams_demo/utils/network_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CartController _cartController = CartController();

  /// To keep track of the color of any article placed in cart
  Map<Article, CartState> itemStates = {};
  @override
  void initState() {
    super.initState();
    homeController.fetchArticles();
  }

  @override
  void dispose() {
    homeController.dispose();
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article List'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CartBadge(
              cartController: _cartController,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: homeController.articleState.stream,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            final homeState = snapShot.data as NetworkState;
            return switch (homeState) {
              NetworkStateLoading() =>
                const Center(child: CircularProgressIndicator.adaptive()),
              NetworkStateSuccess() => _buildArticleList(homeState.data),
              NetworkStateError() =>
                Center(child: Text('Error: ${homeState.errorMessage}')),
            };
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }

  Widget _buildArticleList(List<Article> articles) {
    return RefreshIndicator(
      onRefresh: () {
        homeController.fetchArticles();
        _cartController.clear();
        return Future.value();
      },
      child: GridView.builder(
        itemCount: articles.length,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) => _buildListItem(
          articles[index],
        ),
      ),
    );
  }

  Widget _buildListItem(Article article) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildArticleBody(article),
          _buildAddtoCartButton(article),
        ],
      ),
    );
  }

  Positioned _buildAddtoCartButton(Article article) {
    return Positioned(
      top: 0,
      right: -10,
      child: StreamBuilder(
        stream: _cartController.cartState,
        initialData: CartStateInitial(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cartState = snapshot.data as CartState;
            final iconColor = _getIconColor(cartState, article);

            return IconButton(
              key: ValueKey<int>(article.id),
              onPressed: () {
                _cartController.addToCart(article: article);
                showSnackbar(title: 'Added to cart', context: context);
                itemStates[article] = CartStateAddedToCart();
              },
              icon: Icon(
                Icons.badge,
                color: iconColor,
              ),
            );
          } else {
            return const Text('ERror');
          }
        },
      ),
    );
  }

  Widget _buildArticleBody(Article article) {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            child: Text(
              article.id.toString(),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            article.title.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            article.body.substring(0, 100),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  MaterialColor _getIconColor(CartState cartState, Article article) {
    final cartState = itemStates[article] ?? CartStateInitial();
    if (cartState is CartStateInitial) {
      return Colors.red;
    } else if (cartState is CartStateAddedToCart) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
