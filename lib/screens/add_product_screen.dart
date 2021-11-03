import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/utils/constants.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = 'add-product';
  // ! We want to use this page for adding/ editing products.
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  FocusNode _priceFocusNode;
  FocusNode _descriptionFocusNode;
  TextEditingController _imageUrlController;
  FocusNode _imageUrlFocusNode;
  Map _routeData;
  final _formKey = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  bool _isLoading = false;
  bool _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void initState() {
    super.initState();
    _priceFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _imageUrlController = TextEditingController();
    _imageUrlFocusNode = FocusNode();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _routeData =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final productId = _routeData['id'];
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!(_imageUrlController.text.startsWith('http') ||
              _imageUrlController.text.startsWith('https')) ||
          !(_imageUrlController.text.endsWith('.jpg') ||
              _imageUrlController.text.endsWith('.jpeg') ||
              _imageUrlController.text.endsWith('.png') ||
              _imageUrlController.text.endsWith('.webp'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id != null) {
        await productsProvider.updateProduct(_editedProduct.id, _editedProduct);
      } else {
        try {
          await productsProvider.addProduct(_editedProduct);
        } catch (e) {
          await showDialog<Null>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error!'),
                titleTextStyle: TextStyle(color: Theme.of(context).errorColor),
                content: Text('Something went wrong!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  )
                ],
              );
            },
          );
        }
        // finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text(_routeData['appBarTitle'] ?? appName),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(
                horizontal: marginHorizontal,
                vertical: marginVertical,
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      cursorHeight: cursorHeight,
                      cursorColor: colorPrimary,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Required Field!';
                        } else if (value.length >= 20) {
                          return 'Title shouldn\'t be greater than 20 character';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(),
                      cursorHeight: cursorHeight,
                      cursorColor: colorPrimary,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value ?? 0.0),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Required Field!';
                        } else if (double.tryParse(value) == null) {
                          return 'Please, Enter a valid number';
                        } else if (double.parse(value) <= 0.0) {
                          return 'Please, Enter a number greater than ZERO';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      cursorHeight: cursorHeight,
                      cursorColor: colorPrimary,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Required Field!';
                        } else if (value.length < 10) {
                          return 'Description should be at least 10 character';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          margin: EdgeInsets.only(top: 15.0, right: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? FittedBox(
                                  child: Icon(
                                    Icons.image,
                                    color: colorPrimary,
                                  ),
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            cursorHeight: cursorHeight,
                            cursorColor: colorPrimary,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required Field!';
                              } else if (!(value.startsWith('http') ||
                                  value.startsWith('https'))) {
                                return 'Please, Enter a valid URL';
                              } else if (!(value.endsWith('.jpg') ||
                                  value.endsWith('.jpeg') ||
                                  value.endsWith('.png') ||
                                  value.endsWith('.webp'))) {
                                return 'Please, Enter a valid Image URL';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130),
                      child: ElevatedButton.icon(
                        onPressed: _saveForm,
                        icon: Icon(Icons.save),
                        label: Text(
                          'Save',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
