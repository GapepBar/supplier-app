import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gbim_supplier/models/order/orders.dart';
import 'package:gbim_supplier/models/product/product.dart';

import '../application/notifier/order_cart_notifier.dart';
import '../application/state/order_cart_state.dart';
import '../services/auth_api_service.dart';
import '../services/order_cart_api_service.dart';
import '../services/product_api_service.dart';

final orderCartItemsProvider =
    StateNotifierProvider.autoDispose<OrderCartNotifier, OrderCartState>(
  (ref) {
    return OrderCartNotifier(ref.watch(ordercartApiService));
  },
);

final loginProvider =
    FutureProvider.autoDispose.family<String, Map<String, String>>(
  (ref, mp) {
    final apiRespository = ref.watch(authApiService);

    return apiRespository.login(mp);
  },
);

final fetchOrdersProvider =
    FutureProvider.autoDispose.family<List<Orders>, String>(
  (ref, status) {
    final apiRespository = ref.watch(ordercartApiService);

    return apiRespository.fetchYourOrders(status);
  },
);

final orderdetailProvider = FutureProvider.autoDispose.family<Orders, String>(
  (ref, orderId) {
    final apiRespository = ref.watch(ordercartApiService);

    return apiRespository.orderdetailProvider(orderId);
  },
);

final fetchProductByIdProvider =
    FutureProvider.autoDispose.family<Product, String>(
  (ref, productId) {
    final apiRespository = ref.watch(productApiService);

    return apiRespository.fetchProductById(productId);
  },
);
