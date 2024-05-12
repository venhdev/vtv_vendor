import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../domain/repository/order_vendor_repository.dart';
import '../data_sources/vendor_order_data_source.dart';

class VendorOrderRepositoryImpl implements OrderVendorRepository {
  final VendorOrderDataSource _dataSource;

  VendorOrderRepositoryImpl(this._dataSource);

  @override
  FRespData<MultiOrderEntity> getOrderList() async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getOrderList());
  }

  @override
  FRespData<MultiOrderEntity> getOrderListByStatus(OrderStatus status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getOrderListByStatus(status));
  }

  @override
  FRespData<OrderEntity> updateOrderStatus(String orderId, OrderStatus status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.updateOrderStatus(orderId, status));
  }

  @override
  FRespData<OrderDetailEntity> getOrderDetail(String orderId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getOrderDetail(orderId));
  }
}
