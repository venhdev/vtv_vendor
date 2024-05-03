import 'package:flutter/material.dart';
import 'package:vendor/features/order/domain/repository/order_vendor_repository.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../service_locator.dart';

class VendorHandler {
  //! Order
  // static void updateOrderStatus(BuildContext context, String orderId, OrderStatus status) {
  static void updateOrderStatus(
    BuildContext context,
    String orderId,
    OrderStatus statusAfterUpdate,
    void Function() reloadCallback,
  ) async {
    String statusText(OrderStatus status) {
      switch (status) {
        case OrderStatus.PROCESSING:
          return 'Xác nhận đơn hàng này?';
        case OrderStatus.PICKUP_PENDING:
          return 'Xác nhận đơn hàng này đã sẵn sàng để giao?';
        case OrderStatus.CANCEL:
          return 'Xác nhận hủy đơn hàng này?';
        default:
          return 'Xác nhận ${status.name}';
      }
    }

    final isConfirm = await showDialogToConfirm(
      context: context,
      title: statusText(statusAfterUpdate),
      confirmText: 'Xác nhận',
      dismissText: 'Thoát',
    );

    if (!isConfirm) return;

    sl<OrderVendorRepository>().updateOrderStatus(orderId, statusAfterUpdate).then((respEither) {
      respEither.fold((error) => showDialogToAlert(context, title: Text(error.message ?? 'Lỗi khi chấp nhận đơn hàng')),
          (ok) {
        reloadCallback();
      });
    });
  }

  static void navigateToOrderDetailPage(BuildContext context, String orderId) {
    // fetch order detail
    sl<OrderVendorRepository>().getOrderDetail(orderId).then((respEither) {
      respEither.fold(
        (error) => showDialogToAlert(context, title: Text(error.message ?? 'Lỗi khi lấy thông tin đơn hàng')),
        (ok) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderDetailPage.vendor(
              orderDetail: ok.data!,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      );
    });
  }
}
