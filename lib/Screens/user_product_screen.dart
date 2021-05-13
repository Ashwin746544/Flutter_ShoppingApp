import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/Screens/edit_product_screen.dart';
import 'package:shopApp/providers/products.dart';
import 'package:shopApp/widgets/app_drawer.dart';
import 'package:shopApp/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                }),
          ],
        ),
        drawer: AppDrawer(),
        // here we used futurebuilder because we want that when this page is loaded first time then all the userproduct are updated(without refreshing page).without futurebuilder we have to refreshing manually for getting updated user products.
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshotData) =>
                snapshotData.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer<Products>(
                            builder: (ctx, productsData, _) => ListView.builder(
                                itemCount: productsData.items.length,
                                itemBuilder: (_, i) => UserProductItem(
                                    productsData.items[i].id,
                                    productsData.items[i].title,
                                    productsData.items[i].imageUrl)),
                          ),
                        ),
                      )));
  }
}
// here above in Listview.builder we used Consumer because when we used 'final productsData = Provider.of<Products>(context);' at the top of the build method then FutureBuilder run Again and Again and only shown CircularprogressIndicator on the Screen ,that's why we used consumer on Listview.builer