import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Cart.dart';
import '../widgets/Products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('myShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions f) {
              setState(() {
                if (f == FilterOptions.Favourites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "OnlyFavourite",
                ),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('All Products'),
                value: FilterOptions.All,
              ),
            ],
          ),
          //Da Bas elly he7slo rebuild kol lma cart yb2a feh ta3'eer msh el class kolha!
          //la7eh ch dy elly heya el child bta3 Lconsumer bra elbeld W elly msh htrebuild
          Consumer<Cart>(
            builder: (context, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
    return scaffold;
  }
}
