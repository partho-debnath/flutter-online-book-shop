import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/product_providers.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import './login_screen.dart';
import './product_details_screen.dart';
import './cart_screen.dart';
import './user_profile_screen.dart';
import '../widgets/product_gridView.dart';
import '../widgets/my_badge.dart';
import '../widgets/app_drawer.dart';

enum SelectedOptions { Logout, Profile, Favorite, All }

class NotesScreen extends StatefulWidget {
  static const String routeName = "product-overview";
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool isFavorite = false;
  bool isFirst = true;
  bool isLoad = false;

  Future<bool> _showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) {
      return value ?? false;
    });
  }

  @override
  void didChangeDependencies() {
    if (isFirst == true) {
      Provider.of<ProductsProvider>(context).fetchProducts().then((_) {
        setState(() {
          isLoad = true;
        });
      });
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Order'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    CustomSearchDelegate(productsProvider: productProvider),
              );
            },
            icon: const Icon(Icons.search),
          ),
          Consumer<Cart>(
            builder: (cntxt, cartData, ch) => MyBadge(
              value: cartData.itemCount.toString(),
              color: Colors.amber,
              child: ch as Widget,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routesName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton<SelectedOptions>(
            onSelected: (SelectedOptions selectedOption) async {
              switch (selectedOption) {
                case SelectedOptions.Favorite:
                  setState(() {
                    // productProvider.favourite();
                    isFavorite = true;
                  });
                  break;
                case SelectedOptions.All:
                  setState(() {
                    // productProvider.all();
                    isFavorite = false;
                  });
                  break;
                case SelectedOptions.Logout:
                  final shouldLogout = await _showLogOutDialog(context);
                  if (shouldLogout == true) {
                    await FirebaseAuth.instance.signOut();
                    await Future.delayed(const Duration(seconds: 0));
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, (cntxt) => false,
                          arguments: {});
                    }
                  }
                  break;
                case SelectedOptions.Profile:
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<SelectedOptions>(
                  value: SelectedOptions.All,
                  child: Text('Home'),
                ),
                const PopupMenuItem<SelectedOptions>(
                  value: SelectedOptions.Profile,
                  child: Text('Profile'),
                ),
                const PopupMenuItem<SelectedOptions>(
                  value: SelectedOptions.Favorite,
                  child: Text('Favourite'),
                ),
                const PopupMenuItem<SelectedOptions>(
                  value: SelectedOptions.Logout,
                  child: Text('Logout'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: isLoad == false
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () {
                return productProvider.fetchProducts();
              },
              child: GridViewProducts(isFavorite: isFavorite),
            ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  ProductsProvider productsProvider;
  CustomSearchDelegate({required this.productsProvider});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Product> matchProducts = [];
    for (Product product in productsProvider.items) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        matchProducts.add(product);
      }
    }

    return ListView.builder(
      itemCount: matchProducts.length,
      itemBuilder: (cntxt, index) => ListTile(
        title: Text(matchProducts[index].title),
        subtitle: Text(matchProducts[index].author),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> matchProducts = [];
    for (var product in productsProvider.items) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        matchProducts.add(product);
      }
    }

    return ListView.builder(
      itemCount: matchProducts.length,
      itemBuilder: (cntxt, index) => Card(
        elevation: 5,
        child: ListTile(
          title: Text(matchProducts[index].title),
          subtitle: Text(
              'by: ${matchProducts[index].author}. ${matchProducts[index].edition} edition'),
          trailing: Text('${matchProducts[index].price}'),
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.nameRoute,
              arguments: {'productId': matchProducts[index].id},
            );
          },
        ),
      ),
    );
  }
}
