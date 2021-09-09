import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid_view.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavorites = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshProducts() {
    return Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          PopupMenuButton<FilterOptions>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                if (value == FilterOptions.favorites) {
                  _showFavorites = true;
                } else if (value == FilterOptions.all) {
                  _showFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, value, child) {
              return Badge(
                child: child,
                value: value.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refreshProducts,
              child: ProductsGridView(_showFavorites)),
    );
  }
}

enum FilterOptions {
  favorites,
  all,
}
