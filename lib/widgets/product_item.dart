import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/shared/global_widgets.dart';
import 'package:shop_app/utils/constants.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Widget rebuild');
    return Consumer3<Product, Cart, Auth>(
      builder: (context, product, cart, auth, _) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailsScreen.routeName,
                arguments: product,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.54),
            leading: Consumer<Product>(
              builder: (context, value, _) {
                return IconButton(
                    icon: Icon(
                      value.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 22.0,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      value.toggleFavorite(auth.token, auth.userId);
                      if (product.isFavorite) {
                        GlobalWidgets.showSnackBar(
                          context: context,
                          text:
                              '${product.title} product has been added to favorite',
                          backgroundColor: Colors.green,
                          duration: 1500,
                        );
                      }
                      if (!product.isFavorite) {
                        GlobalWidgets.showSnackBar(
                          context: context,
                          text:
                              '${product.title} product has been removed from favorite',
                          backgroundColor: Colors.red,
                          duration: 1500,
                        );
                      }
                    });
              },
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 22.0,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(
                    product.id, product.price, product.title, product.imageUrl);
                GlobalWidgets.showSnackBar(
                  context: context,
                  text: '${product.title} has been added to cart',
                  // backgroundColor: Colors.green,
                  actionLabel: 'UNDO',
                  onPressedAction: () {
                    cart.removeSingleItem(product.id);
                  },
                );
              },
            ),
            title: Text(
              '${product.title}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
