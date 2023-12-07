import 'dart:convert';
import 'package:gbim_supplier/models/product/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/order/orders.dart';

final productApiService = Provider((ref) => APIServiceProduct());

class APIServiceProduct {
  static var client = http.Client();

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
}
