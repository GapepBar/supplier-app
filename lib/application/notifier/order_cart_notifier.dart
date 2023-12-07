import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gbim_supplier/models/product/product.dart';

import '../../models/cart/cart.dart';
import '../../models/cart/cartitem.dart';
import '../../providers/providers.dart';
import '../../services/order_cart_api_service.dart';
import '../state/order_cart_state.dart';

class OrderCartNotifier extends StateNotifier<OrderCartState> {
  final APIServiceOrderCart _apiService;

  OrderCartNotifier(this._apiService) : super(const OrderCartState()) {
    getCartitems();
  }

  Future<void> getCartitems() async {
    state = state.copyWith(isLoading: true);

    // var cartdata = await _apiService.getCartitemsApi(number);
    // var cartdata = Cart(products: []);
    var cartdata = state.ordercartModel;
    if (cartdata == null) cartdata = Cart(products: []);

    state = state.copyWith(ordercartModel: cartdata);
    state = state.copyWith(isLoading: false);
  }

  Future<void> addCartItems(
      String productId, double quantity, double price) async {
    Product data = await _apiService.fetchProductById(productId);
    // Product data = Product(
    //     productId: '',
    //     name: '',
    //     imageUrl: '',
    //     description: '',
    //     totalQuantity: 1,
    //     quantityType: '',
    //     lowQuantity: 1);

    var newCartitem = CartItem(Item: data, ItemCount: quantity, price: price);

    var updatedItems = state.ordercartModel!.products.toList();
    updatedItems.add(newCartitem);

    Cart newcart = Cart(products: updatedItems);

    print('new cart is: $newcart');

    state = state.copyWith(ordercartModel: newcart);

    print('now state is  ${state.ordercartModel!.products}');

    print('done adding');

    // final data = ref.watch(fetchProductByIdProvider(productId));
    // return data.when(
    //   data: (product) {
    //     print('product inside notifier is: $product');
    //     var newCartitem =
    //         CartItem(Item: product, ItemCount: quantity, price: price);
    //     var updatedItems = state.ordercartModel!.products.toList();
    //     updatedItems.add(newCartitem);
    //     Cart newcart = Cart(products: updatedItems);
    //     state = state.copyWith(ordercartModel: newcart);
    //   },
    //   error: (_, __) {
    //     print('error in fetching the value');
    //   },
    //   loading: () => const Center(child: CircularProgressIndicator()),
    // );
  }

  Future<void> removeCartItems(String productid) async {
    var isCartItemExist = state.ordercartModel!.products
        .firstWhere((prd) => prd.Item.productId == productid);

    var updatedItems = state.ordercartModel!.products.toList();

    updatedItems.remove(isCartItemExist);

    Cart newcart = Cart(products: updatedItems);

    state = state.copyWith(ordercartModel: newcart);
  }

  Future<void> updateCartItem(String prductId, double qty, double price) async {
    print('now state is  ${state.ordercartModel!.products}');

    var isCartItemExist = state.ordercartModel!.products
        .firstWhere((prd) => prd.Item.productId == prductId);

    //created new instance of that product with updated quantity
    CartItem cartProduct =
        CartItem(Item: isCartItemExist.Item, ItemCount: qty, price: price);

    // udated the list
    var updatedItems = state.ordercartModel!.products.toList();
    updatedItems.remove(isCartItemExist);
    updatedItems.add(cartProduct);

    //createing new cart instance with updated data
    Cart newcart = Cart(products: updatedItems);

    //updating the state
    state = state.copyWith(ordercartModel: newcart);
  }

  Future<String> placeOrder(Map<String, dynamic> mp) async {
    String statusdata = await _apiService.placeorder(mp);

    if (statusdata == 'success') {
      var updatedItems = state.ordercartModel!.products.toList();

      updatedItems.clear();

      Cart newcart = Cart(products: updatedItems);

      state = state.copyWith(ordercartModel: newcart);

      return 'success';
    } else {
      return 'Error';
    }
  }
}
