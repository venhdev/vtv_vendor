import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../service_locator.dart';
import '../../../order/domain/repository/order_vendor_repository.dart';
import '../../../order/presentation/pages/vendor_order_purchase_page.dart';

Future<List<RespData<MultiOrderEntity>>> _futureDataOrders() async {
  return Future.wait(
    List.generate(vendorTapPages.length, (index) async {
      return sl<OrderVendorRepository>().getOrderListByStatus(vendorTapPages[index]);
    }),
  );
}

class OrderPurchaseTracking extends StatefulWidget {
  const OrderPurchaseTracking({
    super.key,
  });

  @override
  State<OrderPurchaseTracking> createState() => _OrderPurchaseTrackingState();
}

class _OrderPurchaseTrackingState extends State<OrderPurchaseTracking> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureDataOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //> check if any resp got error >> return empty
          if (snapshot.data!.any((resp) => resp.isLeft())) {
            return const SizedBox.shrink();
          }
          return _trackingInfo(context, dataList: snapshot.data!);
        } else {
          return const Center(
            child: Text(
              'Đang tải dữ liệu đơn hàng...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          );
        }
      },
    );
  }

  Wrapper _trackingInfo(BuildContext context, {required List<RespData<MultiOrderEntity>> dataList}) {
    void navigateToPurchasePage(int index) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return VendorOrderPurchasePage(initialMultiOrders: dataList, initialIndex: index);
          },
        ),
      );
    }

    int getIndex(OrderStatus status) {
      return vendorTapPages.indexWhere((element) => element == status);
    }

    Widget buildTrackingItem(OrderStatus status, {Color? color}) {
      return dataList[getIndex(status)].fold(
        (error) => const SizedBox.shrink(),
        (ok) => OrderTrackingItem(
          ok.data!.orders.length,
          status,
          onPressed: () => navigateToPurchasePage(getIndex(status)),
          color: color,
        ),
      );
    }

    return Wrapper(
      margin: const EdgeInsets.only(top: 8),
      label: const WrapperLabel(labelText: 'Đơn hàng của bạn', icon: Icons.shopping_cart_outlined),
      suffixLabel: Row(
        children: [
          // refresh icon button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),

          TextButton(
              onPressed: () {
                navigateToPurchasePage(0);
              },
              child: const Text('Xem tất cả')),
        ],
      ),
      child: FittedBox(
        child: Wrap(
          children: [
            buildTrackingItem(OrderStatus.PENDING),
            buildTrackingItem(OrderStatus.PROCESSING),
            buildTrackingItem(OrderStatus.PICKUP_PENDING),
            buildTrackingItem(OrderStatus.SHIPPING),
            buildTrackingItem(OrderStatus.WAITING),
          ],
        ),
      ),
    );
  }
}

class OrderTrackingItem extends StatelessWidget {
  const OrderTrackingItem(
    this.count,
    this.status, {
    super.key,
    this.onPressed,
    this.color,
  });

  final int count;
  final OrderStatus status;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Ink(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //# count
              Text(
                count.toString(),
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              //# order status name
              Text(
                StringUtils.getOrderStatusName(status),
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
