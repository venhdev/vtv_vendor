import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/constants/vendor_api.dart';

abstract class VendorOrderDataSource {
  //# order-shop-controller
  Future<SuccessResponse<MultiOrderEntity>> getOrderList();
  Future<SuccessResponse<OrderDetailEntity>> updateOrderStatus(String orderId, OrderStatus status);
  Future<SuccessResponse<OrderDetailEntity>> getOrderDetail(String orderId);
  Future<SuccessResponse<MultiOrderEntity>> getListOrdersByStatus(OrderStatus status);

}

class OrderVendorDataSourceImpl implements VendorOrderDataSource {
  final Dio _dio;

  OrderVendorDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<MultiOrderEntity>> getOrderList() async {
    final url = uriBuilder(path: kAPIVendorOrderListURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<MultiOrderEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => MultiOrderEntity.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<MultiOrderEntity>> getListOrdersByStatus(OrderStatus status) async {
    final url = uriBuilder(path: '$kAPIVendorOrderListStatusURL/${status.name}');

    final response = await _dio.getUri(url);

    return handleDioResponse<MultiOrderEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => MultiOrderEntity.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<OrderDetailEntity>> updateOrderStatus(String orderId, OrderStatus status) async {
    final url = uriBuilder(path: kAPIVendorOrderUpdateStatusURL, pathVariables: {
      'orderId': orderId,
      'status': status.name,
    });

    final response = await _dio.patchUri(url);

    return handleDioResponse<OrderDetailEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => OrderDetailEntity.fromMap(jsonMap),
    );
  }
  
  @override
  Future<SuccessResponse<OrderDetailEntity>> getOrderDetail(String orderId) async{
    final url = uriBuilder(path: '$kAPIVendorOrderDetailURL/$orderId');

    final response = await _dio.getUri(url);

    return handleDioResponse<OrderDetailEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => OrderDetailEntity.fromMap(jsonMap),
    );
  
  }
}
