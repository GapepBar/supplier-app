import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/cart/cartitem.dart';
import '../models/order/orders.dart';
import '../models/product/product.dart';

final ordercartApiService = Provider((ref) => APIServiceOrderCart());

class APIServiceOrderCart {
  static var client = http.Client();

  Future<List<Orders>> fetchYourOrders(String status) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = (prefs.getString('userId'));
    String? category = (prefs.getString('category'));

    var ur = "${Config.apiURL}${Config.fetchordersbystatus}";
    var url = Uri.parse(ur);

    print('url is: $url');

    var response = await client.post(url,
        headers: requestHeaders,
        body: jsonEncode(
            {'userId': userId, 'status': status, 'category': category}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return ordersFromJson(data['data']);
    } else {
      return [];
    }
  }

  Future<Orders> orderdetailProvider(String orderId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var ur = "${Config.apiURL}${Config.fetchorderdetail}";
    var url = Uri.parse(ur);

    print('url is: $url');

    print(orderId);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode({'orderId': orderId}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Orders.fromJson(data['data']);
    } else {
      return Orders(
          orderId: 'orderId',
          date: DateTime(DateTime.april),
          orderStatus: 'orderStatus',
          productsItem: [],
          billedItems: [],
          bill: 0,
          deliveryCharges: 0);
    }
  }

  Future<Product> fetchProductById(String productId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var ur = "${Config.apiURL}${Config.fetchProductbyId}";
    var url = Uri.parse(ur);

    print('url is: $url');

    print(productId);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode({'productId': productId}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Product.fromJson(data['data']);
    } else {
      return Product(
          productId: '',
          name: '',
          imageUrl: '',
          description: '',
          totalQuantity: 0,
          quantityType: '',
          lowQuantity: 0);
    }
  }

  Future<String> placeorder(Map<String, dynamic> mp) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    String orderId = mp['orderId'];
    List<CartItem> productList = mp['cartList'];
    double bill = mp['bill'];
    double deliveryCharges = mp['deliveryCharges'];

    List<Map<String, dynamic>> cartList = [];
    for (int i = 0; i < productList.length; i++) {
      String productId = productList[i].Item.productId;
      double qty = productList[i].ItemCount;
      double price = productList[i].price;
      Map<String, dynamic> temp = {
        'product': productId,
        'quantity': qty,
        'price': price
      };

      cartList.add(temp);
    }

    var ur = "${Config.apiURL}${Config.placeOrderBySupplier}";
    var url = Uri.parse(ur);

    print('url is: $url');

    print(orderId);
    print(cartList);

    var response = await client.post(url,
        headers: requestHeaders,
        body: jsonEncode({
          'orderId': orderId,
          'list': cartList,
          'bill': bill,
          'deliveryCharges': deliveryCharges
        }));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data['message'];
    } else {
      return 'failure';
    }
  }
}
