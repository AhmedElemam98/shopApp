import 'package:flutter/material.dart';
import '../widgets/ProductItem.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showOnlyFavourites;
  ProductsGrid(this._showOnlyFavourites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = _showOnlyFavourites?productsData.favItems:productsData.items;
    print(products.length);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(   
          //builder: (context) => products[i],
          value:products[i] ,
          child: ProductItem(

          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
