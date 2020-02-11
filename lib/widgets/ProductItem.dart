import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/Cart.dart';
import '../providers/auth.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;

  //const ProductItem({this.id, this.title, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth =Provider.of<Auth>(context,listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(product.title),
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: ()async {
                  await product.toggleFavouriteStatus(auth.token,auth.userId);
                },
              ),
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context)
                    .hideCurrentSnackBar(); //3lshan lw d7't mrten wra ba3d y3'fey el2ola
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added to card!'),
                  backgroundColor: Colors.black87,
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                )); //Attached to the nearest Scaffold
              },
            )),
      ),
    );
  }
}
