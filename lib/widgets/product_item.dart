import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/providers/auth.dart';
import 'package:shopApp/providers/cart.dart';
import '../Screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    // here we use listen:false ,even though favourite icon is changable because we used Consumer ,Consumer is used to change certain part of widget without rebuilts whole widget(means without running built method).
    // print('rebuilts..');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Hero(
                tag: product.id,
                              child: FadeInImage(
                  placeholder: AssetImage('assets/images/product-placeholder.png'),image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              )),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                icon: product.isFavourite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  product.toggleFavouriteStatus(auth.token,auth.userId);
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Item Added Successfully to Cart!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () => cart.removeSingleItem(product.id)),
                  ));
                },
                color: Theme.of(context).accentColor),
          )),
    );
  }
}
