import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../../../../../service_locator.dart';
import '../../../domain/repository/vendor_product_repository.dart';
import 'add_update_shop_category_page.dart';
import 'shop_category_products_page.dart';

// this page is used to show all shop categories of a vendor
class ShopCategoryManagePage extends StatelessWidget {
  const ShopCategoryManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý danh mục cửa hàng')),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Thêm danh mục'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddUpdateShopCategoryPage(),
          ));
        },
      ),
      body: FutureBuilder(
        future: sl<VendorProductRepository>().getAllShopCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final respEither = snapshot.data!;
            return respEither.fold(
              (error) => MessageScreen.error(error.message),
              (ok) {
                return ListView.builder(
                  itemCount: ok.data!.length,
                  itemBuilder: (context, index) {
                    final shopCategory = ok.data![index];
                    return ShopCategoryItem(shopCategory: shopCategory);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return MessageScreen.error(snapshot.error.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ShopCategoryItem extends StatelessWidget {
  const ShopCategoryItem({super.key, required this.shopCategory});

  final ShopCategoryEntity shopCategory;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShopCategoryProductsPage(shopCategory: shopCategory),
          ));
        },
        leading: CircleAvatar(radius: 20, child: ImageCacheable(shopCategory.image)),
        title: Text(shopCategory.name),
        trailing: Text('${shopCategory.countProduct} sản phẩm'),
      ),
    );
  }
}
