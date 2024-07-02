import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/vendor_order_repository.dart';

class VendorOrderDetailPage extends StatefulWidget {
  const VendorOrderDetailPage({super.key, required this.orderDetail});

  final OrderDetailEntity orderDetail;

  @override
  State<VendorOrderDetailPage> createState() => _VendorOrderDetailPageState();
}

class _VendorOrderDetailPageState extends State<VendorOrderDetailPage> {
  late OrderDetailEntity _orderDetail;

  @override
  void initState() {
    super.initState();
    _orderDetail = widget.orderDetail;
  }

  void fetchOrderDetail() async {
    final respEither = await showDialogToPerform(
      context,
      dataCallback: () => sl<VendorOrderRepository>().getOrderDetail(_orderDetail.order.orderId!),
      closeBy: (context, result) => Navigator.of(context).pop(result),
    );

    respEither?.fold(
      (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi tải thông tin đơn hàng!'),
      (ok) => setState(() => _orderDetail = ok.data!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrderDetailPage.vendor(
      orderDetail: _orderDetail,
      onBack: () => Navigator.of(context).pop(),
      onRefresh: () async => fetchOrderDetail(),
      onAcceptCancelPressed: (orderId) async {
        log('onAcceptCancelPressed');
        // _handleAcceptCancelOrder(context, orderId);
        final respEither = await _handleAcceptCancelOrder(context, orderId);

        respEither?.fold(
          (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi hủy đơn hàng!'),
          (ok) => setState(() => _orderDetail = ok.data!),
        );
      },
      onAcceptPressed: (orderId) async {
        log('onAcceptPressed');
        final respEither = await _handleAcceptOrder(context, orderId);

        respEither?.fold(
          (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi xác nhận đơn hàng!'),
          (ok) => setState(() => _orderDetail = ok.data!),
        );
      },
      onPackedPressed: (orderId) async {
        log('onPackedPressed');
        // _handlePackedOrder(context, orderId);
        final respEither = await _handlePackedOrder(context, orderId);

        respEither?.fold(
          (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi đóng gói đơn hàng!'),
          (ok) => setState(() => _orderDetail = ok.data!),
        );
      },
    );
  }
}

Future<RespData<OrderDetailEntity>?> _handleAcceptOrder(BuildContext context, String orderId) async {
  final isConfirm = await showDialogToConfirm<bool?>(
    context: context,
    title: 'Xác nhận đơn hàng?',
    titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    content: 'Sau khi xác nhận, đơn hàng sẽ được chuyển sang trạng thái "Đang xử lý"',
    confirmText: 'Xác nhận',
    confirmBackgroundColor: Colors.green.shade300,
    dismissText: 'Thoát',
  );

  if ((isConfirm ?? false) && context.mounted) {
    return await showDialogToPerform(
      context,
      dataCallback: () => sl<VendorOrderRepository>().updateOrderStatus(orderId, OrderStatus.PROCESSING),
      closeBy: (context, result) => Navigator.of(context).pop(result),
    );
  } else {
    return null;
  }
}

Future<RespData<OrderDetailEntity>?> _handlePackedOrder(BuildContext context, String orderId) async {
  final isConfirm = await showDialogToConfirm<bool?>(
    context: context,
    title: 'Xác nhận đã đóng gói?',
    titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    content: 'Sau khi xác nhận, đơn hàng sẽ được chuyển sang trạng thái "Đã đóng gói"',
    confirmText: 'Xác nhận',
    confirmBackgroundColor: Colors.green.shade300,
    dismissText: 'Thoát',
  );

  if ((isConfirm ?? false) && context.mounted) {
    return await showDialogToPerform(
      context,
      dataCallback: () => sl<VendorOrderRepository>().updateOrderStatus(orderId, OrderStatus.PICKUP_PENDING),
      closeBy: (context, result) => Navigator.of(context).pop(result),
    );
  } else {
    return null;
  }
}

Future<RespData<OrderDetailEntity>?> _handleAcceptCancelOrder(BuildContext context, String orderId) async {
  final isConfirm = await showDialogToConfirm<bool?>(
    context: context,
    title: 'Xác nhận hủy đơn hàng?',
    titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    content: 'Sau khi xác nhận, đơn hàng sẽ được chuyển sang trạng thái "Đã hủy"',
    confirmText: 'Xác nhận',
    confirmBackgroundColor: Colors.green.shade300,
    dismissText: 'Thoát',
  );

  if ((isConfirm ?? false) && context.mounted) {
    return await showDialogToPerform(
      context,
      dataCallback: () => sl<VendorOrderRepository>().updateOrderStatus(orderId, OrderStatus.CANCEL),
      closeBy: (context, result) => Navigator.of(context).pop(result),
    );
  } else {
    return null;
  }
}
