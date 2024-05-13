import 'package:flutter/material.dart';

import '../../../shop/presentation/components/shop_info_detail_view.dart';
import '../components/order_purchase_tracking.dart';
import 'add_update_product_page.dart';

class VendorHomePage extends StatelessWidget {
  const VendorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const ShopInfoDetailView(),
        const OrderPurchaseTracking(),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const AddUpdateProductPage();
                },
              ),
            );
          },
          child: const Text('Thêm sản phẩm'),
        ),
      ],
    );
  }
}
