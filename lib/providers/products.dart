import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
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
    */
  ];

  List<Product> get favItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    const url = "https://shop-app-79238.firebaseio.com/products.json";

    try {
      final jsonString = await http.get(url);

      final jsonResponse = json.decode(jsonString.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];

      jsonResponse.forEach((prodId, prodValue) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodValue['title'],
          description: prodValue['description'],
          imageUrl: prodValue['imageUrl'],
          price: prodValue['price'],
          isFavourite: prodValue['isFavourite']
        ));
      });

      _items = loadedProducts;
      notifyListeners();
      // print(jsonResponse);
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = "https://shop-app-79238.firebaseio.com/products";
    final response = await http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavourite': product.isFavourite,
            }))
        .then((response) {
      if (!(response.statusCode >= 200 && response.statusCode < 300)) {
        throw Exception('error occured');
      }
    }).catchError((error) {
      throw error;
    });
  }

  // Future<void> addProduct(Product product) async {
  //   const url = "https://shop-app-79238.firebaseio.com/";

  //   //Momken a3mla Be .then W .catch error bdl el 'try..catch'
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           'title': product.title,
  //           'description': product.description,
  //           'price': product.price,
  //           'imageUrl': product.imageUrl,
  //           'isFavourite': product.isFavourite,
  //         }));

  //     // print('status code is${response.statusCode}');
  //     final newProduct = Product(
  //       id: json.decode(response.body)['name'],
  //       description: product.description,
  //       imageUrl: product.imageUrl,
  //       price: product.price,
  //       title: product.title,
  //     );

  //     _items.add(newProduct);
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> updateProduct(String productId, Product newProduct) async {
    int prodIndex = _items.indexWhere((prod) => prod.id == productId);
    if (prodIndex >= 0) {
      var url = "https://shop-app-79238.firebaseio.com/";
      //patch bt3ml override aw merge bm3na as7 so,msh h3'er el isFavourite
      await http
          .patch(url,
              body: json.encode({
                'title': newProduct.title,
                'description': newProduct.description,
                'price': newProduct.price,
                'imageUrl': newProduct.imageUrl,
              }))
          .catchError((error) {
        throw error;
      });

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Product findProductById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> removeProduct(String id) async {
    var url = "https://shop-app-79238.firebaseio.com/products/$id";
    await http.delete(url);
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  void changeFavouriteById(int index) {
    _items[index].isFavourite = !_items[index].isFavourite;
    notifyListeners();
  }
}
