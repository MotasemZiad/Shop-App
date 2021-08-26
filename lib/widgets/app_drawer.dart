import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/utils/constants.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150.0,
            color: colorPrimary,
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Shop App',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                ProductsOverviewScreen.routeName,
              );
            },
            // tileColor: colorPrimary.withOpacity(0.14),
            leading: Icon(
              Icons.shop,
              color: colorPrimary,
              size: 30.0,
            ),
            title: Text(
              'Shop',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorPrimary,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
            // tileColor: colorPrimary.withOpacity(0.14),
            leading: Icon(
              Icons.payment,
              color: colorPrimary,
              size: 30.0,
            ),
            title: Text(
              'Orders',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorPrimary,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                UserProductsScreen.routeName,
              );
            },
            // tileColor: colorPrimary.withOpacity(0.14),
            leading: Icon(
              Icons.edit,
              color: colorPrimary,
              size: 30.0,
            ),
            title: Text(
              'Manage Products',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
