import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../models/product.dart';
import '../providers/products.dart';
import '../widgets/loading_screen.dart';

class EditUserProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditUserProductScreenState createState() =>
      new _EditUserProductScreenState();
}

class _EditUserProductScreenState extends State<EditUserProductScreen> {
  final TextEditingController _imgController = new TextEditingController();

  final _priceNode = new FocusNode();
  final _descNode = new FocusNode();
  final _imgNode = new FocusNode();

  final _form = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Product _product = new Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  bool _isKeyboardOpen = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    new KeyboardVisibilityNotification().addNewListener(
        onChange: (bool visible) {
      setState(() {
        _isKeyboardOpen = visible;
      });
    });

    _imgNode.addListener(_updateImageURL);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    final _args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    if (_args != null) {
      final _id = _args['id'];
      _product = Provider.of<Products>(context).findProduct(_id);
    }

    _imgController.text = _product.imageUrl;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceNode.dispose();
    _descNode.dispose();
    _imgNode.dispose();
    _imgController.dispose();

    super.dispose();
  }

  void _updateImageURL() {
    if (!_imgNode.hasFocus) {
      if ((!_imgController.text.startsWith('http') ||
              !_imgController.text.startsWith('https')) &&
          (!_imgController.text.endsWith('jpg'))) {
        return;
      }
    }

    setState(() {});
  }

  Future _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();

    setState(() => _isLoading = true);

    if (_product.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_product.id, _product);

      setState(() => _isLoading = false);

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_product);

        setState(() => _isLoading = false);

        Navigator.of(context).pop();
      } catch (error) {
        setState(() => _isLoading = false);

        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            content: const Text('Something went wrong!'),
            duration: const Duration(seconds: 2),
            action: new SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      status: _isLoading,
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Add Product'),
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: new Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            child: productForm(),
          ),
        ),
        floatingActionButton: _isKeyboardOpen
            ? new Container()
            : new Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: new RaisedButton(
                    color: Theme.of(context).accentColor,
                    elevation: 4,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(4),
                    ),
                    child: new Text(
                      _product.id != null ? 'Update Product' : 'Add Product',
                      style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _saveForm()),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  InputDecoration formInputDecoration(String label) {
    return new InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: const OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.black54,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.blue,
          ),
        ));
  }

  Form productForm() {
    return new Form(
      key: _form,
      child: new ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          new TextFormField(
              initialValue: _product.title,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: formInputDecoration('Title'),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product title';
                }

                return null;
              },
              onSaved: (value) {
                _product = new Product(
                    id: _product.id,
                    title: value,
                    description: _product.description,
                    price: _product.price,
                    imageUrl: _product.imageUrl);
              }),
          const SizedBox(
            height: 8,
          ),
          new TextFormField(
              initialValue: _product.price.toString(),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _priceNode,
              decoration: formInputDecoration('Price'),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(value) <= 0) {
                  return 'Price must be greated than 0';
                }

                return null;
              },
              onSaved: (value) {
                _product = new Product(
                    id: _product.id,
                    title: _product.title,
                    description: _product.description,
                    price: double.parse(value),
                    imageUrl: _product.imageUrl);
              }),
          const SizedBox(
            height: 8,
          ),
          new TextFormField(
              minLines: 2,
              maxLines: 7,
              initialValue: _product.description,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              focusNode: _descNode,
              decoration: formInputDecoration('Description'),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_imgNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a product description';
                }
                if (value.length < 10) {
                  return 'Description should a least 10 characters';
                }

                return null;
              },
              onSaved: (value) {
                _product = new Product(
                    id: _product.id,
                    title: _product.title,
                    description: value,
                    price: _product.price,
                    imageUrl: _product.imageUrl);
              }),
          const SizedBox(
            height: 8,
          ),
          new Row(children: [
            new Container(
              width: 100,
              height: 100,
              decoration: new BoxDecoration(border: new Border.all(width: 1)),
              child: _imgController.text.isEmpty
                  ? const Text('No Image')
                  : new Image.network(_imgController.text),
            ),
            const SizedBox(
              width: 4,
            ),
            new Expanded(
              child: TextFormField(
                  controller: _imgController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  focusNode: _imgNode,
                  decoration: formInputDecoration('Image URL'),
                  onFieldSubmitted: (_) => _saveForm(),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a product image url';
                    }
                    if (!value.startsWith('http') &&
                        !value.startsWith('https')) {
                      return 'Please enter valid url';
                    }
                    if (!value.endsWith('.jpg') &&
                        !value.endsWith('.jpeg') &&
                        !value.endsWith('.png')) {
                      return 'Please enter valid image url';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _product = new Product(
                        id: _product.id,
                        title: _product.title,
                        description: _product.description,
                        price: _product.price,
                        imageUrl: value);
                  }),
            ),
          ]),
        ],
      ),
    );
  }
}
