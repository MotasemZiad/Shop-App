import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/utils/constants.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) =>
      items.firstWhere((element) => element.id == id);

  final String authToken;
  final String userId;
  ProductsProvider(this.authToken, this.userId, this._items);

  Future<void> fetchProducts([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = '$baseUrl/$productsNode.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;

      url = '$baseUrl/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = '$baseUrl/$productsNode.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: product.toJson(),
      );
      final userProductsResponse = await http.post(
        url,
        body: {
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price.toString(),
          'creatorId': userId,
        },
      );
      print(userProductsResponse.body);
      print(userProductsResponse.statusCode);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // * at the beginning of the list.
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> removeProduct(String id) async {
    final url = '$baseUrl/$productsNode/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      print(response.statusCode);
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Couldn\'t delete product');
    }
    existingProduct = null;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      final productIndex = _items.indexWhere((element) => element.id == id);
      if (productIndex >= 0) {
        final url = '$baseUrl/$productsNode/$id.json?auth=$authToken';
        await http.put(
          url,
          body: newProduct.toJson(),
        );
        _items[productIndex] = newProduct;
      } else {
        print('Something went wrong');
      }
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }
}
