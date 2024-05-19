import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

abstract class VendorOrderRepository {
  //# order-shop-controller
  FRespData<MultiOrderEntity> getOrderList();
  FRespData<MultiOrderEntity> getOrderListByStatus(OrderStatus status);
  FRespData<OrderDetailEntity> updateOrderStatus(String orderId, OrderStatus status);
  FRespData<OrderDetailEntity> getOrderDetail(String orderId);
}
