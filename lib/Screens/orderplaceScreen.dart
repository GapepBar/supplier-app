// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gbim_supplier/Widgets/order/productOrderTile.dart';
import 'package:intl/intl.dart';

import '../models/order/orders.dart';
import '../providers/providers.dart';

class OrderPlaceScreen extends ConsumerStatefulWidget {
  OrderPlaceScreen({super.key});

  @override
  ConsumerState<OrderPlaceScreen> createState() => _OrderPlaceScreenState();
}

class _OrderPlaceScreenState extends ConsumerState<OrderPlaceScreen> {
  double _deliveryCharges = 0.0;
  double totalBill = 0;

  TextEditingController _chargetextFieldController = TextEditingController();

  Widget orderSummary(WidgetRef ref, BuildContext context, String orderId) {
    final data = ref.watch(orderdetailProvider(orderId));

    return data.when(
      data: (order) {
        return orderDetail(ref, order);
      },
      error: (_, __) => Center(child: const Text('Error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget orderDetail(WidgetRef ref, Orders order) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          /* ------------------------- Order Summary Container ------------------------ */
          /* -------------------------------------------------------------------------- */
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                boxShadow: const [BoxShadow(blurRadius: 1, spreadRadius: 0)],
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Summary",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(vertical: 8),
                  child: Text(
                    "${order.productsItem.length} items in this order",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),

                /* --------------------------- List tile for item --------------------------- */
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ProductOrderTile(
                          mp: order.productsItem[i],
                        );
                      },
                      itemCount: order.productsItem.length,
                    ),
                  ],
                ),
              ],
            ),
          ),
          /* ----------------------------- Upper container ---------------------------- */
          SizedBox(height: 20),
          /* ----------------------- Container For Bill Details ----------------------- */
          billContainer(ref),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => addDeliveryCharges(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(blurRadius: 1, spreadRadius: 0)],
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.green),
              width: double.infinity,
              child: Text(
                'Add Delivery Charges',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget billContainer(WidgetRef ref) {
    final CartItemModel = ref.watch(orderCartItemsProvider);
    var searchdata = CartItemModel.ordercartModel!.products;

    double bill = 0;

    for (int i = 0; i < searchdata.length; i++) {
      var data = searchdata[i];
      bill += data.price;
      totalBill += data.price;
    }
    totalBill = bill + _deliveryCharges;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 1, spreadRadius: 0)],
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bill Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("MRP"),
              Text('₹${bill.toString()}'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery Charges"),
              Text("₹${_deliveryCharges.toString()}"),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bill Total",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${totalBill.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  void addDeliveryCharges() async {
    double? inputVal = await showDialog<double>(
      context: context,
      builder: (context) => _displayDialogBox(context),
    );
    print('Dialog one returned value ---> $inputVal');

    setState(() {
      _deliveryCharges = inputVal ?? 0.0;
      totalBill += _deliveryCharges;
    });
  }

  Widget _displayDialogBox(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: Text('Enter Delivery Charges'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _chargetextFieldController,
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.red,
          textColor: Colors.white,
          child: const Text('CANCEL'),
          onPressed: () {
            double tempMp = 0;
            Navigator.pop(context, tempMp);
          },
        ),
        MaterialButton(
          color: Colors.green,
          textColor: Colors.white,
          child: const Text('OK'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String chargetemp = _chargetextFieldController.text.toString();
              _chargetextFieldController.clear();

              double tempVal = double.parse(chargetemp);
              Navigator.pop(context, tempVal);
            } else
              return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var orderData = (ModalRoute.of(context)?.settings.arguments ??
        <String, String>{}) as Map;
    String orderId = orderData['orderId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: orderSummary(ref, context, orderId),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          final cartViewModel = ref.read(orderCartItemsProvider.notifier);
          int val = cartViewModel.state.ordercartModel!.products.length;
          if (val == 0) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Cart is Empty')));
          } else {
            Navigator.of(context).pushNamed('/previewOrderScreen', arguments: {
              'orderId': orderId,
              'deliveryCharges': _deliveryCharges.toString()
            });
          }
        },
        child: Container(
          height: 60,
          alignment: Alignment(0, 0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Text(
            'Preview Order',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
