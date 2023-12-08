import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gbim_supplier/models/product/product.dart';

import '../../providers/providers.dart';

class ProductOrderTile extends ConsumerStatefulWidget {
  Map<String, dynamic> mp;
  ProductOrderTile({super.key, required this.mp});

  @override
  ConsumerState<ProductOrderTile> createState() =>
      _ProductOrderTileState(mp: mp);
}

class _ProductOrderTileState extends ConsumerState<ProductOrderTile> {
  Map<String, dynamic> mp;
  _ProductOrderTileState({required this.mp});

  double counter = 0;
  TextEditingController _qtytextFieldController = TextEditingController();
  TextEditingController _pricetextFieldController = TextEditingController();

  void editHandler() async {
    Map<String, double>? inputmp = await showDialog<Map<String, double>>(
      context: context,
      builder: (context) =>
          _displayDialogBox(context, mp['product']['quantityType']),
    );
    print('Dialog one returned value ---> $inputmp');

    setState(() {
      counter = inputmp!['qtyVal'] ?? 0.0;
    });

    if (inputmp!['qtyVal'] == 0.0) {
      deleteHandler();
    } else {
      final cartViewModel = ref.read(orderCartItemsProvider.notifier);
      cartViewModel.updateCartItem(mp['product']['productId'],
          inputmp['qtyVal'] ?? 0, inputmp['price'] ?? 0);
    }
  }

  void deleteHandler() {
    print('delete tapped');
    setState(() {
      counter = 0;
    });
    final cartViewModel = ref.read(orderCartItemsProvider.notifier);
    cartViewModel.removeCartItems(mp['product']['productId']);
  }

  Widget addTile(scWidth) {
    final CartItemModel = ref.watch(orderCartItemsProvider);

    if (CartItemModel.isLoading) {
      return SpinKitThreeInOut(
        size: 25,
        color: Theme.of(context).primaryColor,
      );
    }

    var searchdata = CartItemModel.ordercartModel!.products;

    bool flag = false;
    for (int i = 0; i < searchdata.length; i++) {
      var data = searchdata[i];
      if (mp['product']['productId'] == data.Item.productId) {
        setState(() {
          counter = data.ItemCount;
        });
        flag = true;
        break;
      }
    }
    if (flag == false) {
      setState(() {
        counter = 0;
      });
    }

    // return Container();
    return buildAddTile(scWidth);
  }

  Widget buildAddTile(scWidth) {
    return counter != 0
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment(0, 0),
                  width: scWidth * 0.48 * 0.36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: Colors.black,
                  ),
                  child: Text(
                    '$counter' + ' ' + mp['product']['quantityType'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: scWidth * 0.48 * 0.36,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => editHandler(),
                          child: Icon(
                            Icons.edit,
                            size: 22,
                            color: const Color.fromARGB(255, 173, 205, 231),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () => deleteHandler(),
                          child: Icon(
                            Icons.delete,
                            size: 22,
                            color: Color.fromARGB(255, 220, 119, 111),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )
        : GestureDetector(
            onTap: () async {
              Map<String, double>? inputmp =
                  await showDialog<Map<String, double>>(
                context: context,
                builder: (context) =>
                    _displayDialogBox(context, mp['product']['quantityType']),
              );
              print('Dialog one returned value ---> $inputmp');

              setState(() {
                counter = inputmp!['qtyVal'] ?? 0.0;
              });

              if (inputmp!['qtyVal'] != 0.0) {
                final cartViewModel = ref.read(orderCartItemsProvider.notifier);
                cartViewModel.addCartItems(mp['product']['productId'],
                    inputmp['qtyVal'] ?? 0, inputmp['price'] ?? 0);
              }
            },
            child: Container(
              alignment: Alignment(0, 0),
              width: scWidth * 0.48 * 0.36,
              height: scWidth * 0.48 * 0.20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(),
                color: Colors.white,
              ),
              child: const Text('ADD'),
            ),
          );
  }

  Widget _displayDialogBox(BuildContext context, String qtyType) {
    final _formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: Text('Fill the quantity'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _qtytextFieldController,
            ),
            SizedBox(height: 15),
            Text(qtyType),
            SizedBox(
              height: 15,
            ),
            Text("Price"),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _pricetextFieldController,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.red,
          textColor: Colors.white,
          child: const Text('CANCEL'),
          onPressed: () {
            Map<String, double> tempMp = {'qtyVal': 0.0, 'price': 0.0};
            Navigator.pop(context, tempMp);
          },
        ),
        MaterialButton(
          color: Colors.green,
          textColor: Colors.white,
          child: const Text('OK'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String qtytemp = _qtytextFieldController.text.toString();
              _qtytextFieldController.clear();
              String pricetemp = _pricetextFieldController.text.toString();
              _pricetextFieldController.clear();

              Map<String, double> tempMp = {
                'qtyVal': double.parse(qtytemp),
                'price': double.parse(pricetemp)
              };
              Navigator.pop(context, tempMp);
            } else
              return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scSize = MediaQuery.of(context).size;
    // final scHeight = scSize.height;
    final scWidth = scSize.width;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Image.network(mp['product']['imageUrl']),
      ),
      title: Text(mp['product']['name']),
      subtitle: Text(
          "${mp['quantity'].toString()} ${mp['product']['quantityType'].toString()}"),
      trailing: Container(
        child: buildAddTile(scWidth),
      ),
    );
  }
}
