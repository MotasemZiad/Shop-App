import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/utils/constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(product.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          height: 300.0,
          width: double.infinity,
          child: Image.network(
            loadedProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 12.0),
        Text(
          '\$${loadedProduct.price}',
          style: TextStyle(
            color: Colors.green,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.0),
        Container(
            padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
            width: double.infinity,
            child: Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            )),
      ])),
    );
  }
}
