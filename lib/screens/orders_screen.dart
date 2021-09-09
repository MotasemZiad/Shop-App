import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error!\n Can\'t load data from the server.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, ordersProvider, child) {
                    return ordersProvider.orders.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) =>
                                OrderItem(ordersProvider.orders[index]),
                            itemCount: ordersProvider.orders.length,
                          )
                        : Center(
                            child: Text(
                              'You haven\'t make any order yet',
                              style: TextStyle(
                                color: colorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                          );
                  },
                );
              }
            }
          }),
    );
  }
}
