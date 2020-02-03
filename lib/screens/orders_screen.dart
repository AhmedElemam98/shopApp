import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart'
    show Orders; //Because there is awidget whith the same name of orderItem
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
      ),
    );
  }
}
