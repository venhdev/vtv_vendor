import 'package:flutter/material.dart';
import 'package:vendor/features/order/domain/repository/vendor_order_repository.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/handler/vendor_handler.dart';
import '../../../../service_locator.dart';

const List<OrderStatus> vendorTapPages = [
  // null,
  OrderStatus.PENDING,
  OrderStatus.WAITING,
  OrderStatus.PROCESSING,
  OrderStatus.PICKUP_PENDING,
  OrderStatus.SHIPPING,
  OrderStatus.DELIVERED,
  OrderStatus.COMPLETED,
  OrderStatus.RETURNED,
  OrderStatus.CANCEL,
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
    } else if (status == OrderStatus.RETURNED) {
      return sl<VendorOrderRepository>().getListOrdersByMultiStatus([OrderStatus.RETURNED, OrderStatus.REFUNDED]);
    }
     else {
      return sl<VendorOrderRepository>().getListOrdersByStatus(status);
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
          buttonLabel: 'Đã đóng gói',
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
          label: 'Đơn hàng đã bị hủy!',
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
      case OrderStatus.PICKUP_PENDING:
        return OrderPurchaseItemAction(
          label: 'Hiện thị mã QR vận đơn',
          buttonLabel: 'Mở',
          onPressed: () async {
            final respEither = await showDialogToPerform(
              context,
              dataCallback: () => sl<VendorOrderRepository>().getOrderDetail(order.orderId!),
              closeBy: (context, result) => Navigator.of(context).pop(result),
            );

            final orderDetail = respEither?.fold((error) => null, (ok) => ok.data!);
            if (orderDetail == null || !context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return QrViewPage(data: orderDetail.transport!.transportId);
                },
              ),
            );
          },
          backgroundColor: Colors.blue.shade100,
          buttonColor: Colors.blue.shade400,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
