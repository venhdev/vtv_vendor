import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

abstract class VendorOrderRepository {
  //# order-shop-controller
  FRespData<MultiOrderEntity> getOrderList();
  FRespData<MultiOrderEntity> getListOrdersByStatus(OrderStatus status);
  FRespData<OrderDetailEntity> updateOrderStatus(String orderId, OrderStatus status);
  FRespData<OrderDetailEntity> getOrderDetail(String orderId);
  FRespData<MultiOrderEntity> getListOrdersByMultiStatus(List<OrderStatus> statuses); // custom
}
