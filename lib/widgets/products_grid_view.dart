import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGridView extends StatelessWidget {
  final bool _showFavorites;

  ProductsGridView(this._showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    bool isFavoriteEmpty = productsProvider.favoriteItems.isEmpty;
    final products = _showFavorites
        ? isFavoriteEmpty
            ? null
            : productsProvider.favoriteItems
        : productsProvider.items;
    return products == null
        ? Center(
            child: Text(
              'You haven\'t add any product to favorite',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: colorPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 6.0,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(),
              );
            },
            padding: const EdgeInsets.all(paddingAll),
          );
  }
}
