import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/add_product_screen.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';
  final String appBarTitle = 'Add Product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: const Text('User Products'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return _refreshProducts(context);
                },
                child: Consumer<ProductsProvider>(
                  builder: (context, productsProvider, _) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: marginHorizontal,
                      vertical: marginVertical,
                    ),
                    child: productsProvider.items.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) => Column(
                              children: [
                                UserProductItem(
                                  id: productsProvider.items[index].id,
                                  title: productsProvider.items[index].title,
                                  imageUrl:
                                      productsProvider.items[index].imageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                            itemCount: productsProvider.items.length,
                          )
                        : Center(
                            child: Text(
                              'You didn\'t add any product',
                              style: TextStyle(
                                color: colorPrimary,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddProductScreen.routeName,
            arguments: {'appBarTitle': appBarTitle},
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: colorPrimary,
      ),
    );
  }
}
