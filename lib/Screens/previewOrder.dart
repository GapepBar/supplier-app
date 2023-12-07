import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart/cartitem.dart';
import '../providers/providers.dart';

class PreviewOrderScreen extends ConsumerWidget {
  PreviewOrderScreen({super.key});
  double bill = 0;

  Widget buildPreview(WidgetRef ref, double deliveryCharges) {
    final CartItemModel = ref.watch(orderCartItemsProvider);
    var data = CartItemModel.ordercartModel!.products;

    for (int i = 0; i < data.length; i++) {
      var dat = data[i];
      bill += dat.price;
    }

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
                        "Product List",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.symmetric(vertical: 8),
                  child: Text(
                    "${data.length} items in this order",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),

                /* --------------------------- List tile for item --------------------------- */
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.network(data[i].Item.imageUrl),
                          ),
                          title: Text(data[i].Item.name),
                          subtitle: Text(
                              "${data[i].ItemCount.toString()} ${data[i].Item.quantityType.toString()}"),
                          trailing: Container(
                            child: Text("₹${data[i].price}"),
                          ),
                        );
                      },
                      itemCount: data.length,
                    ),
                  ],
                ),
              ],
            ),
          ),
          /* ----------------------------- Upper container ---------------------------- */
          SizedBox(height: 20),
          /* ----------------------- Container For Bill Details ----------------------- */
          billContainer(bill, deliveryCharges),
        ]),
      ),
    );
  }

  Widget billContainer(double bill, double deliveryCharges) {
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
              Text("Items Bill"),
              Text('₹${bill.toString()}'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery Charges"),
              Text("₹${deliveryCharges.toString()}"),
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
                '₹${(bill + deliveryCharges).toString()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  void placeorder(WidgetRef ref, BuildContext context, String orderId,
      double deliveryCharges) async {
    final CartItemModel = ref.watch(orderCartItemsProvider);
    List<CartItem> previewProducts = CartItemModel.ordercartModel!.products;

    Map<String, dynamic> mp = {
      'orderId': orderId,
      'cartList': previewProducts,
      'bill': bill,
      'deliveryCharges': deliveryCharges
    };

    final cartViewModel = ref.read(orderCartItemsProvider.notifier);
    String msg = await cartViewModel.placeOrder(mp);

    if (msg == 'success') {
      Navigator.of(context).pushNamed('/orderSuccessScreen');
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Some error occured')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var orderData = (ModalRoute.of(context)?.settings.arguments ??
        <String, String>{}) as Map;
    String orderId = orderData['orderId'] ?? '';
    double deliveryCharges = double.parse(orderData['deliveryCharges']);
    // String orderId = '1234';

    return Scaffold(
      appBar: AppBar(
        title: Text('Preview Order'),
      ),
      body: buildPreview(ref, deliveryCharges),
      bottomNavigationBar: GestureDetector(
        onTap: () => placeorder(ref, context, orderId, deliveryCharges),
        child: Container(
          height: 60,
          alignment: Alignment(0, 0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Text(
            'Place Order',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
