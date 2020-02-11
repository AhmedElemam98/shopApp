import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './Cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
    final String _authToken;
    final String _userId;
  
  Orders(this._authToken,this._userId,this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }


    Future<void> fetchAndSetOrders() async {
    final url = "https://shop-app-79238.firebaseio.com/orders/$_userId.json?auth=$_authToken";

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if(extractedData==null)return;

      final List<OrderItem> loadedProducts = [];

      extractedData.forEach((orderId, orderValue) {
        loadedProducts.add(OrderItem(
          id: orderId,
          amount: orderValue['amount'],
          dateTime: DateTime.parse(orderValue['dateTime']),
          products: (orderValue['products'] as List<dynamic>).map(
            (item)=>CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            )

          ).toList(),

        ));
      });

      _orders = loadedProducts.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;

    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = "https://shop-app-79238.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    var currentTime = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((cartitem) => {
                    'id': cartitem.id,
                    'price': cartitem.price,
                    'quantity': cartitem.quantity,
                    'title': cartitem.title
                  })
              .toList(),
          'dateTime': currentTime
              .toIso8601String(), //toIso8601String-->sahl t7wlha L DateTime Tany
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: currentTime,
            products: cartProducts));
  }
}
