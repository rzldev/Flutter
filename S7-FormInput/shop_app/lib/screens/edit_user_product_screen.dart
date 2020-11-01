import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../providers/products.dart';

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
  Product _product = new Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  bool _isKeyboardOpen = false;

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

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();

    if (_product.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_product.id, _product);
    } else {
      _product = new Product(
          id: '${Provider.of<Products>(context, listen: false).products.length + 1}',
          title: _product.title,
          description: _product.description,
          price: _product.price,
          imageUrl: _product.imageUrl);
      Provider.of<Products>(context, listen: false).addProduct(_product);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
          // child: ProductForm(
          //   priceNode: _priceNode,
          //   descNode: _descNode,
          //   imgNode: _imgNode,
          //   imgController: _imgController,
          //   saveForm: _saveForm,
          //   product: _product,
          //   form: _form,
          // ),
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
                  onPressed: _saveForm),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

// class ProductForm extends StatelessWidget {
//   ProductForm({
//     @required this.form,
//     @required this.priceNode,
//     @required this.descNode,
//     @required this.imgNode,
//     @required this.imgController,
//     @required this.saveForm,
//     @required this.product,
//   });

//   final GlobalKey<FormState> form;
//   final FocusNode priceNode;
//   final FocusNode descNode;
//   final FocusNode imgNode;
//   final TextEditingController imgController;
//   final Function saveForm;
//   Product product;

//   @override
//   Widget build(BuildContext context) {
//     InputDecoration formInputDecoration(String label) {
//       return InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.black54),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: Colors.black54,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: Colors.blue,
//             ),
//           ));
//     }

//     return Form(
//       key: form,
//       child: ListView(
//         padding: EdgeInsets.only(top: 8),
//         children: [
//           TextFormField(
//               initialValue: product.title,
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//               decoration: formInputDecoration('Title'),
//               onFieldSubmitted: (_) {
//                 FocusScope.of(context).requestFocus(priceNode);
//               },
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter product title';
//                 }

//                 return null;
//               },
//               onSaved: (value) {
//                 product = Product(
//                     id: product.id,
//                     title: value,
//                     description: product.description,
//                     price: product.price,
//                     imageUrl: product.imageUrl);
//               }),
//           SizedBox(
//             height: 8,
//           ),
//           TextFormField(
//               initialValue: product.price.toString(),
//               keyboardType: TextInputType.number,
//               textInputAction: TextInputAction.next,
//               focusNode: priceNode,
//               decoration: formInputDecoration('Price'),
//               onFieldSubmitted: (_) {
//                 FocusScope.of(context).requestFocus(descNode);
//               },
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter product price';
//                 }
//                 if (double.tryParse(value) == null) {
//                   return 'Please enter a valid number';
//                 }
//                 if (double.parse(value) <= 0) {
//                   return 'Price must be greated than 0';
//                 }

//                 return null;
//               },
//               onSaved: (value) {
//                 product = Product(
//                     id: product.id,
//                     title: product.title,
//                     description: product.description,
//                     price: double.parse(value),
//                     imageUrl: product.imageUrl);

//                 print(product.title);
//                 print(product.price);
//               }),
//           SizedBox(
//             height: 8,
//           ),
//           TextFormField(
//               minLines: 2,
//               maxLines: 7,
//               initialValue: product.description,
//               keyboardType: TextInputType.multiline,
//               textInputAction: TextInputAction.next,
//               focusNode: descNode,
//               decoration: formInputDecoration('Description'),
//               onFieldSubmitted: (_) {
//                 FocusScope.of(context).requestFocus(imgNode);
//               },
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter a product description';
//                 }
//                 if (value.length < 10) {
//                   return 'Description should a least 10 characters';
//                 }

//                 return null;
//               },
//               onSaved: (value) {
//                 product = Product(
//                     id: product.id,
//                     title: product.title,
//                     description: value,
//                     price: product.price,
//                     imageUrl: product.imageUrl);
//               }),
//           SizedBox(
//             height: 8,
//           ),
//           Row(children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(border: Border.all(width: 1)),
//               child: imgController.text.isEmpty
//                   ? Text('No Image')
//                   : Image.network(imgController.text),
//             ),
//             SizedBox(
//               width: 4,
//             ),
//             Expanded(
//               child: TextFormField(
//                   controller: imgController,
//                   keyboardType: TextInputType.url,
//                   textInputAction: TextInputAction.done,
//                   focusNode: imgNode,
//                   decoration: formInputDecoration('Image URL'),
//                   onFieldSubmitted: (_) => saveForm(),
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Please enter a product image url';
//                     }
//                     if (!value.startsWith('http') &&
//                         !value.startsWith('https')) {
//                       return 'Please enter valid url';
//                     }
//                     if (!value.endsWith('.jpg') &&
//                         !value.endsWith('.jpeg') &&
//                         !value.endsWith('.png')) {
//                       return 'Please enter valid image url';
//                     }

//                     return null;
//                   },
//                   onSaved: (value) {
//                     product = Product(
//                         id: product.id,
//                         title: product.title,
//                         description: product.description,
//                         price: product.price,
//                         imageUrl: value);
//                   }),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }
// }
