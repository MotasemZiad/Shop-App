import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/shared/global_widgets.dart';
import 'package:shop_app/utils/constants.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.imageUrl,
      @required this.price,
      @required this.quantity});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 36.0,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        margin:
            EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: 6.0),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (_) {
        return GlobalWidgets.presentDialog(
          context: context,
          text: 'Are you sure you want to delete this product?',
          title: 'Warning!',
          titleColor: Colors.red,
          actionTitle1: 'Yes',
          actionFunction1: () {
            Navigator.of(context).pop(true);
          },
          actionTitle2: 'No',
          actionFunction2: () {
            Navigator.of(context).pop(false);
          },
        );
      },
      child: Card(
        margin:
            EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: 6.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(imageUrl),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
