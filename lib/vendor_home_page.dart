import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import 'service_locator.dart';
import 'features/auth/domain/repository/profile_repository.dart';
import 'features/auth/presentation/components/shop_info_detail_view.dart';
import 'features/product/presentation/components/menu_item.dart';
import 'features/product/presentation/components/order_purchase_tracking.dart';
import 'features/product/presentation/pages/manage_product/add_update_product_page.dart';
import 'features/product/presentation/pages/manage_category/shop_category_manage_page.dart';
import 'features/product/presentation/pages/manage_product/vendor_product_page.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key, required this.onItemTapped});

  final void Function(int index) onItemTapped;

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //# shop profile
          FutureBuilder(
            future: sl<ProfileRepository>().getShopProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final resultEither = snapshot.data!;

                return resultEither.fold(
                  (error) => MessageScreen.error(error.message),
                  (ok) => ShopInfoDetailView(shopId: ok.data!.shopId),
                );
              } else if (snapshot.hasError) {
                return MessageScreen.error(snapshot.error.toString());
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          //# order tracking
          const OrderPurchaseTracking(), //> use const will avoid rebuild
          const SizedBox(height: 8),

          //# menu action
          Wrapper(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                MenuItem('Sản phẩm của tôi', Icons.my_library_books, onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const VendorProductPage();
                      },
                    ),
                  );
                }),
                MenuItem('Thêm sản phẩm', Icons.playlist_add, onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const AddUpdateProductPage();
                      },
                    ),
                  );
                }),
                MenuItem('Quản lý Voucher', Icons.card_giftcard, onPressed: () => widget.onItemTapped(2)),
                MenuItem('Quản lý Danh mục', Icons.card_giftcard, onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const ShopCategoryManagePage();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
