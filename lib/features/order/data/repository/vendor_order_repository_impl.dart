import 'package:dartz/dartz.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../domain/repository/vendor_order_repository.dart';
import '../datasources/vendor_order_data_source.dart';

class VendorOrderRepositoryImpl implements VendorOrderRepository {
  final VendorOrderDataSource _dataSource;

  VendorOrderRepositoryImpl(this._dataSource);

  @override
  FRespData<MultiOrderEntity> getOrderList() async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getOrderList());
  }

  @override
  FRespData<MultiOrderEntity> getListOrdersByStatus(OrderStatus status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getListOrdersByStatus(status));
  }

  @override
  FRespData<OrderDetailEntity> updateOrderStatus(String orderId, OrderStatus status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.updateOrderStatus(orderId, status));
  }

  @override
  FRespData<OrderDetailEntity> getOrderDetail(String orderId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getOrderDetail(orderId));
  }

  @override
  FRespData<MultiOrderEntity> getListOrdersByMultiStatus(List<OrderStatus> statuses) async {
    try {
      return await Future.wait(statuses.map((status) => _dataSource.getListOrdersByStatus(status))).then((value) {
        final List<OrderEntity> orders = [];
        int count = 0;
        int totalPayment = 0;
        int totalPrice = 0;

        for (var multiOrder in value) {
          orders.addAll(multiOrder.data!.orders);
          count += multiOrder.data!.count;
          totalPayment += multiOrder.data!.totalPayment;
          totalPrice += multiOrder.data!.totalPrice;
        }

        final MultiOrderEntity result = MultiOrderEntity(
          orders: orders,
          count: count,
          totalPayment: totalPayment,
          totalPrice: totalPrice,
        );
        return Right(SuccessResponse<MultiOrderEntity>(data: result));
      });
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }
}
