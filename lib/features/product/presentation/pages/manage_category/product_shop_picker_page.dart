import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../../service_locator.dart';
import '../../../domain/repository/vendor_product_repository.dart';
import '../../components/product_of_shop_category_item.dart';

// this page is used to pick products to add to a shop category
class ProductShopPickerPage extends StatefulWidget {
  const ProductShopPickerPage({super.key, required this.excludeProductIds});

  final List<int>? excludeProductIds;

  @override
  State<ProductShopPickerPage> createState() => _ProductShopPickerPageState();
}

class _ProductShopPickerPageState extends State<ProductShopPickerPage> {
  late LazyListController<ProductEntity> lazyListController;
  List<int> selectedProductIds = [];

  @override
  void initState() {
    super.initState();
    lazyListController = LazyListController<ProductEntity>(
      items: [],
      paginatedData: (page, size) => sl<VendorProductRepository>().getProductPageByStatus(page, size, Status.ACTIVE),
      useGrid: false,
      size: 200, //! load all products once
    )..init(
        // filter data to exclude products
        onInitCompleted: () {
          final excludeProductIds = widget.excludeProductIds;
          if (excludeProductIds != null && excludeProductIds.isNotEmpty) {
            lazyListController.items.removeWhere((element) => excludeProductIds.contains(element.productId));
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn sản phẩm'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedProductIds);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
      body: LazyListBuilder(
        lazyListController: lazyListController,
        itemBuilder: (context, index, data) => item(data),
      ),
    );
  }

  Widget item(ProductEntity data) => Row(
        children: [
          //# radio
          Checkbox(
            value: selectedProductIds.contains(data.productId),
            onChanged: (value) {
              setState(() {
                if (value!) {
                  selectedProductIds.add(data.productId);
                } else {
                  selectedProductIds.remove(data.productId);
                }
              });
            },
          ),

          //# product info
          Expanded(
            child: ProductOfShopCategoryItem(
                product: data,
                onPressed: () {
                  setState(() {
                    if (selectedProductIds.contains(data.productId)) {
                      selectedProductIds.remove(data.productId);
                    } else {
                      selectedProductIds.add(data.productId);
                    }
                  });
                }),
          ),
        ],
      );
}
