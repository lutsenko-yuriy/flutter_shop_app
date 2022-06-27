import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/all_products.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  static const productIdArgument = 'productId';

  const EditProductScreen({Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _shouldBeInit = true;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  var _initialProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_shouldBeInit) {
      var productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product = context.read<AllProducts>().productById(productId);
        _editedProduct = Product(
            id: productId,
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl);

        _initialProduct = _editedProduct;

        _imageUrlController.text = product.imageUrl;
      }
    }

    _shouldBeInit = false;
  }

  void _updateImageUrl() {
    var textToMatch = _imageUrlController.text;
    if (!_imageUrlFocusNode.hasFocus &&
        textToMatch.isNotEmpty &&
        RegExp('(https?:\/\/.*\.(?:png|jpg|jpeg))', caseSensitive: false)
            .hasMatch(textToMatch)) {
      setState(() {});
    }
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

  Future<void > _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    if (_editedProduct == _initialProduct) {
      return;
    }

    setState(() {
      this._isLoading = true;
    });
    try {
      await context
          .read<AllProducts>().addOrReplaceProduct(_editedProduct);
    } catch (error) {
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'))
            ],
          ));
    } finally {
      setState(() {
        this._isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var standardBody = Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            TextFormField(
              initialValue: _initialProduct.title,
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocusNode),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            TextFormField(
                initialValue: _initialProduct.price.toStringAsFixed(2),
                decoration: InputDecoration(labelText: 'Price in €'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a price bigger than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl);
                }),
            TextFormField(
              initialValue: _initialProduct.description,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: _imageUrlController.text.isEmpty
                      ? Text('Enter a URL')
                      : FittedBox(
                          child: Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                        )),
                ),
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  onFieldSubmitted: (_) => _saveForm(),
                  onEditingComplete: () {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid URL with a image';
                    }
                    if (!RegExp('(https?:\/\/.*\.(?:png|jpg|jpeg))',
                            caseSensitive: false)
                        .hasMatch(value)) {
                      return 'The given URL is not a URL with an image';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: value);
                  },
                ))
              ],
            ),
          ],
        ),
      ),
    );

    var loadingScreen = Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedProduct.id == null
            ? 'Add a new product'
            : 'Edit the product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading ? loadingScreen : standardBody,
    );
  }
}
