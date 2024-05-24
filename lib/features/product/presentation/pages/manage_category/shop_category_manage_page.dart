import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../../../../../service_locator.dart';
import '../../../domain/repository/vendor_product_repository.dart';
import 'add_update_shop_category_page.dart';
import 'shop_category_products_page.dart';

// this page is used to show all shop categories of a vendor
class ShopCategoryManagePage extends StatefulWidget {
  const ShopCategoryManagePage({super.key});

  @override
  State<ShopCategoryManagePage> createState() => _ShopCategoryManagePageState();
}

class _ShopCategoryManagePageState extends State<ShopCategoryManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý danh mục cửa hàng')),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Thêm danh mục'),
        onPressed: () async {
          final rs = await Navigator.of(context).push<bool>(MaterialPageRoute(
            builder: (context) => const AddUpdateShopCategoryPage(),
          ));

          if (rs ?? false) setState(() {});
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
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: ok.data!.length,
                    itemBuilder: (context, index) {
                      final shopCategory = ok.data![index];
                      return ShopCategoryItem(
                        shopCategory: shopCategory,
                        onRefresh: () => setState(() {}),
                      );
                    },
                  ),
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
  const ShopCategoryItem({super.key, required this.shopCategory, required this.onRefresh});

  final ShopCategoryEntity shopCategory;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onTap: () {
                Navigator.of(context).push<bool>(MaterialPageRoute(
                  builder: (context) => ShopCategoryProductsPage(shopCategory: shopCategory),
                ));
              },
              leading: CircleAvatar(radius: 20, child: ImageCacheable(shopCategory.image)),
              title: Text(shopCategory.name),
              subtitle: Text('${shopCategory.countProduct} sản phẩm'),
            ),
          ),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Sửa'),
                    onTap: () async {
                      final rs = await Navigator.of(context).push<bool>(MaterialPageRoute(
                        builder: (context) => AddUpdateShopCategoryPage(shopCategory: shopCategory),
                      ));
                      // close popup menu
                      if (context.mounted) Navigator.of(context).pop();

                      if (rs ?? false) {
                        onRefresh();
                      }
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Xóa'),
                    onTap: () async {
                      final isConfirm = await showDialogToConfirm<bool>(
                          context: context,
                          title: 'Xác nhận xóa danh mục',
                          content: 'Bạn có chắc chắn muốn xóa danh mục này?');

                      if (isConfirm ?? false) {
                        final respEither =
                            await sl<VendorProductRepository>().deleteShopCategory(shopCategory.categoryShopId);
                        respEither.fold(
                          (error) => Fluttertoast.showToast(msg: error.message ?? 'Xóa danh mục thất bại'),
                          (ok) {
                            Fluttertoast.showToast(msg: 'Xóa danh mục thành công');
                            onRefresh();
                          },
                        );
                      }
                      if (context.mounted) Navigator.of(context).pop(); // close popup menu
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
