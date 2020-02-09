import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    var url = "https://shop-app-79238.firebaseio.com/products/$id.json";
    var currenFacourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      await http.patch(url,
          body: json.encode({
            'isFavourite': isFavourite,
          }));
    } catch (error) {
      isFavourite = currenFacourite;
      notifyListeners();
      print(error.toString());
    }
  }

}
