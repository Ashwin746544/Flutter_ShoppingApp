import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/Screens/cart_screen.dart';
import 'package:shopApp/providers/cart.dart';
import 'package:shopApp/providers/products.dart';
import 'package:shopApp/widgets/app_drawer.dart';
import 'package:shopApp/widgets/badge.dart';
// import 'package:provider/provider.dart';
// import 'package:shopApp/providers/products.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourites = false;
  var _init = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context,).fetchAndSet(); Won't Work
    // Future.delayed(Duration.zero).then((_) => Provider.of<Products>(
    //       context,listen: false
    //     ).fetchAndSet());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        _isLoading = false;
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('MyShop'), actions: [
        PopupMenuButton(
            onSelected: (FilterOptions selectedvalue) {
              // if (selectedvalue == FilterOptions.Favourites) {
              //   productsContainer.showFavouritesOnly();
              // } else {
              //   productsContainer.showAll();
              // }
              // here we can use provider ,but when we want to changes in only one Screen(product_overview_screen) or widget then we should use stateful widget,otherwise you can use provider when we want to changes for App-wide changes or multiple widgets.
              setState(() {
                if (selectedvalue == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
                  PopupMenuItem(
                    child: Text('Only Favourites'),
                    value: FilterOptions.Favourites,
                  ),
                  PopupMenuItem(
                    child: Text('Show All'),
                    value: FilterOptions.All,
                  ),
                ]),
        Consumer<Cart>(
          builder: (_, cart, ch) =>
              Badge(child: ch, value: cart.itemCount.toString()),
          child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              }),
          //  here we put IconButton in as a child of Consumer ,benefit of that is when batch is rebuilds then IconButton is not rebuild and we also not need that
        )
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
