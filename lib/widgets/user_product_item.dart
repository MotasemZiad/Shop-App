import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/add_product_screen.dart';
import 'package:shop_app/shared/global_widgets.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  final String appBarTitle = 'Edit Product';

  UserProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(imageUrl),
        radius: 32.0,
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.yellow.shade700,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AddProductScreen.routeName,
                  arguments: {
                    'id': id,
                    'appBarTitle': appBarTitle,
                  },
                );
              },
            ),
            SizedBox(
              width: 4.0,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                GlobalWidgets.presentDialog(
                  context: context,
                  text: 'Are you sure you want to delete this product?',
                  title: 'Warning!',
                  actionTitle1: 'Yes',
                  actionFunction1: () {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .removeProduct(id);
                    Navigator.pop(context);
                    GlobalWidgets.showSnackBar(
                      context: context,
                      text: 'Item deleted successfully',
                      duration: 2000,
                    );
                  },
                  actionTitle2: 'No',
                  actionFunction2: () {
                    Navigator.pop(context);
                  },
                  titleColor: Colors.red,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
