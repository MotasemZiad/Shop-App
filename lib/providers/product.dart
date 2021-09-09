import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.price,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final url = '$baseUrl/$productsNode/$id.json';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (_) {
      _setFavoriteValue(oldStatus);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      isFavorite: map['isFavorite'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
