import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/shared/global_widgets.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
          backgroundColor: colorPrimary,
        ),
        body: Column(
          children: [
            _buildCardTotal(cart, orders, context),
            SizedBox(
              height: 4.0,
            ),
            Text(
              'Your Cart Items',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: colorPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            cart.itemCount == 0
                ? Expanded(
                    child: Center(
                        child: Text(
                      'Empty Cart',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    )),
                  )
                : Expanded(
                    child: ListView.builder(
                    itemBuilder: (context, index) {
                      return CartItem(
                        id: cart.items.values.toList()[index].id,
                        productId: cart.items.keys.toList()[index],
                        imageUrl: cart.items.values.toList()[index].imageUrl,
                        title: cart.items.values.toList()[index].title,
                        quantity: cart.items.values.toList()[index].quantity,
                        price: cart.items.values.toList()[index].price,
                      );
                    },
                    itemCount: cart.itemCount,
                  ))
          ],
        ));
  }

  Card _buildCardTotal(Cart cart, Orders orders, BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Total:', style: TextStyle(fontSize: 20.0)),
            SizedBox(
              width: 6.0,
            ),
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6.color,
                  fontSize: 16.0,
                ),
              ),
              backgroundColor: colorPrimary,
            ),
            Spacer(),
            OrderButton(cart: cart),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({@required this.cart});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              if (widget.cart.itemCount > 0) {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                GlobalWidgets.showSnackBar(
                  context: context,
                  text: 'Successful Order!\nCheck out your orders',
                  backgroundColor: Colors.green,
                  duration: 2500,
                );
                widget.cart.clearCart();
              }
              // else {
              //   GlobalWidgets.showSnackBar(
              //     context: context,
              //     text:
              //         'Your cart is empty!\nTry to add some products to the cart.',
              //     backgroundColor: Colors.red,
              //     duration: 2500,
              //   );
              // }
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW!',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
