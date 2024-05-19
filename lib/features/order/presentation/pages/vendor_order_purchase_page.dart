import 'package:flutter/material.dart';
import 'package:vendor/features/order/domain/repository/vendor_order_repository.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/handler/vendor_handler.dart';
import '../../../../service_locator.dart';

const List<OrderStatus> vendorTapPages = [
  // null,
  OrderStatus.PENDING, // 0
  OrderStatus.PROCESSING, // 1
  OrderStatus.PICKUP_PENDING, // 2
  OrderStatus.SHIPPING, // 3
  OrderStatus.DELIVERED, // 4
  OrderStatus.COMPLETED, // 5
  OrderStatus.WAITING, // 6
  OrderStatus.CANCEL, // 7
];

class VendorOrderPurchasePage extends StatefulWidget {
  const VendorOrderPurchasePage({super.key, this.initialMultiOrders, this.initialIndex = 0});

  final List<RespData<MultiOrderEntity>>? initialMultiOrders;
  final int initialIndex;

  @override
  State<VendorOrderPurchasePage> createState() => _VendorOrderPurchasePageState();
}

class _VendorOrderPurchasePageState extends State<VendorOrderPurchasePage> {
  FRespData<MultiOrderEntity> _dataCallback(OrderStatus? status) async {
    if (status == null) {
      return sl<VendorOrderRepository>().getOrderList();
    } else {
      return sl<VendorOrderRepository>().getOrderListByStatus(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrderPurchasePage.vendor(
      appBarTitle: 'Đơn hàng',
      dataCallback: _dataCallback,
      initialMultiOrders: widget.initialMultiOrders,
      vendorItemBuilder: (order, onRefresh) => OrderPurchaseItem(
        order: order,
        onPressed: () => VendorHandler.navigateToOrderDetailPage(context, orderId: order.orderId!),
        actionBuilder: (status) => buildVendorAction(status, order, onRefresh, context),
      ),
      pageController: OrderPurchasePageController(
        tapPages: vendorTapPages,
        initialIndex: widget.initialIndex,
      ),
    );
  }

  Widget buildVendorAction(OrderStatus status, OrderEntity order, VoidCallback onRefresh, BuildContext context) {
    switch (status) {
      case OrderStatus.PENDING:
        return OrderPurchaseItemAction(
          label: 'Xác nhận đơn hàng này?',
          buttonLabel: 'Xác nhận',
          onPressed: () => VendorHandler.updateOrderStatus(
            context,
            order.orderId!,
            OrderStatus.PROCESSING,
            onRefresh,
          ),
          backgroundColor: Colors.blue.shade100,
          buttonColor: Colors.blue.shade200,
        );
      case OrderStatus.PROCESSING:
        return OrderPurchaseItemAction(
          label: 'Đơn hàng đã đóng gói xong?',
          buttonLabel: 'Đóng gói xong',
          onPressed: () => VendorHandler.updateOrderStatus(
            context,
            order.orderId!,
            OrderStatus.PICKUP_PENDING,
            onRefresh,
          ),
          backgroundColor: Colors.orange.shade100,
          buttonColor: Colors.orange.shade400,
        );
      case OrderStatus.WAITING:
        return OrderPurchaseItemAction(
          label: 'Đơn hàng đã bị hủy?',
          buttonLabel: 'Xác nhận hủy',
          onPressed: () => VendorHandler.updateOrderStatus(
            context,
            order.orderId!,
            OrderStatus.CANCEL,
            onRefresh,
          ),
          backgroundColor: Colors.red.shade100,
          buttonColor: Colors.red.shade400,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
