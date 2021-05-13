import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/providers/orders.dart' show Orders;
import 'package:shopApp/widgets/app_drawer.dart';
import 'package:shopApp/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;
  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Provider.of<Orders>(context, listen: false)
  //       .setAndFetchOrders()
  //       .then((value) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        // here below we used FutureBuilder because using that we avoid initState method And Stateful Widget(which is used for calling setAndFetchOrders() method and showing CircularProgressIndicator) 
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).setAndFetchOrders(),
            builder: (ctx, snapshotData) {
              if (snapshotData.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshotData.error != null) {
                  // Do Something to Handle error!
                  return Center(
                  child: Text('An error occured!'),
                );
// here we used Consumer because when we used 'final orderData = Provider.of<Orders>(context);' at the top of the build method then FutureBuilder run Again and Again and only shown CircularprogressIndicator on the Screen ,that's why we used consumer on Listview.builer
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderItem(orderData.orders[i])),
                  );
                }
              }
            })
        // _isLoading ? Center(
        //     child: CircularProgressIndicator(),
        //   )
        // : ListView.builder(
        //     itemCount: orderData.orders.length,
        //     itemBuilder: (ctx, i) => OrderItem(orderData.orders[i])),
        );
  }
}
