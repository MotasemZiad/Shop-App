import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Blue Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://i.ebayimg.com/images/g/hnsAAOSwCcFfJHB2/s-l300.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://ae01.alicdn.com/kf/HTB1Sb8bNpXXXXa6XpXXq6xXFXXXc/Camisa-Masculina-Maxi-Men-Shrit-Cotton-Casual-Plus-Size-Mens-Shirts-Camisas-T-shirt-Camisas-Camiseta.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Red T-Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p6',
      title: 'White T-Shirt',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://www.suprely.com/wp-content/uploads/2019/03/Men-Short-Sleeve-T-Shrit-elegant-strapless-neck-casual-T-shirt-Funny-T-Shirt.jpg',
    ),
    Product(
      id: 'p7',
      title: 'T-Shirt',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://ae01.alicdn.com/kf/HTB1VslCknZmx1VjSZFGq6yx2XXaV/Blue-Floral-See-Through-Fishnet-Shrit-Men-2019-New-Sexy-Slim-Fit-Transparent-Clubwear-Dress-Shirt.jpg_Q90.jpg_.webp',
    ),
    Product(
      id: 'p8',
      title: 'A Jacket',
      description: 'You are my hero.',
      price: 49.99,
      imageUrl: 'https://m.media-amazon.com/images/I/41gEjl0hySL.jpg',
    ),
  ];

  List<Product> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) =>
      items.firstWhere((element) => element.id == id);

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); // * at the beginning of the list.
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
    } else {
      print('Something went wrong');
    }
    notifyListeners();
  }
}
