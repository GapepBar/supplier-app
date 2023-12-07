// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../models/order/orders.dart';

class OrderItem extends StatelessWidget {
  Orders order;
  String navigatedBy;
  OrderItem({super.key, required this.order, required this.navigatedBy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ListTile(
        onTap: () {
          if (navigatedBy == 'orderScreen') {
            Navigator.of(context).pushNamed('/orderplaceScreen',
                arguments: {'orderId': order.orderId});
          } else {
            Navigator.of(context).pushNamed('/orderSummaryScreen',
                arguments: {'orderId': order.orderId});
          }
        },
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[200],
          child: const ClipOval(
              child: Image(
                  image: CachedNetworkImageProvider(
                      'https://img.freepik.com/free-vector/delivery-service-illustrated_23-2148505081.jpg?w=2000'),
                  fit: BoxFit.contain)),
        ),
        title: Text('Order Id: ${order.orderId.toUpperCase()}'),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(order.date),
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        trailing: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.navigate_next),
          ],
        ),
        tileColor: Colors.white,
        minVerticalPadding: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
