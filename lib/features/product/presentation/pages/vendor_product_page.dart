import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/dto/add_update_product_param.dart';
import '../../domain/repository/vendor_product_repository.dart';
import 'add_update_product_page.dart';

const size = 10;

const List<Status> _tabPage = [
  Status.ACTIVE,
  Status.INACTIVE,
  Status.DELETED,
  Status.LOCKED,
];

String vendorProductStatusName(Status method) {
  switch (method) {
    case Status.ACTIVE:
      return 'Đang hoạt động';
    case Status.INACTIVE:
      return 'Tạm ẩn';
    case Status.DELETED:
      return 'Đã xóa';
    case Status.LOCKED:
      return 'Bị khóa';
    case Status.CANCEL: // REVIEW
      return 'Đã hủy';
    default:
      return method.name;
  }
}

FRespData<ProductPageResp> paginatedDataByStatus(Status status, int page) async {
  switch (status) {
    case Status.ACTIVE:
      return await sl<VendorProductRepository>().getProductByStatus(page, size, Status.ACTIVE);
    case Status.INACTIVE:
      return await sl<VendorProductRepository>().getProductByStatus(page, size, Status.INACTIVE);
    case Status.DELETED:
      return await sl<VendorProductRepository>().getProductByStatus(page, size, Status.DELETED);
    case Status.LOCKED:
      return await sl<VendorProductRepository>().getProductByStatus(page, size, Status.LOCKED);
    default:
      throw Exception('Invalid status');
  }
}

class VendorProductPage extends StatefulWidget {
  const VendorProductPage({
    super.key,
  });

  @override
  State<VendorProductPage> createState() => _VendorProductPageState();
}

class _VendorProductPageState extends State<VendorProductPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabPage.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sản phẩm của tôi'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabPage.map((e) => Tab(text: vendorProductStatusName(e))).toList(),
          ),
        ),
        body: TabBarView(
          // prevent swipe
          physics: const NeverScrollableScrollPhysics(),
          children: _tabPage.map((e) => TabViewByStatus(status: e)).toList(),
        ),
      ),
    );
  }
}

class TabViewByStatus extends StatefulWidget {
  const TabViewByStatus({
    super.key,
    required this.status,
  });

  final Status status;

  @override
  State<TabViewByStatus> createState() => _TabViewByStatusState();
}

class _TabViewByStatusState extends State<TabViewByStatus> {
  late LazyListController<ProductEntity> lazyController;

  @override
  void initState() {
    super.initState();
    lazyController = LazyListController<ProductEntity>(
      items: [],
      paginatedData: (page) => paginatedDataByStatus(widget.status, page),
      scrollController: ScrollController(),
      auto: true,
      useGrid: false,
      // showLoadMoreButton: true,
    )..init();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        lazyController.refresh();
      },
      child: LazyListBuilder<ProductEntity>(
        lazyController: lazyController,
        itemBuilder: (context, index, data) => VendorProductItem(
          product: data,
          onHidePressed: () async {
            final respEither = await sl<VendorProductRepository>().updateProductStatus(
              data.productId.toString(),
              data.status == Status.ACTIVE.name ? Status.INACTIVE : Status.ACTIVE,
            );

            respEither.fold(
              (error) => null,
              (ok) => lazyController.removeAt(index),
            );
          },
          onDeleteProduct: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Xác nhận xóa sản phẩm'),
                content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final respEither = await sl<VendorProductRepository>().updateProductStatus(
                        data.productId.toString(),
                        Status.DELETED,
                      );

                      respEither.fold(
                        (error) => null,
                        (ok) => lazyController.removeAt(index),
                      );

                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: const Text('Xóa'),
                  ),
                ],
              ),
            );
          },
          onRestorePressed: () async {
            final respEither = await sl<VendorProductRepository>().restoreProduct(
              data.productId.toString(),
            );

            respEither.fold(
              (error) => null,
              (ok) => lazyController.removeAt(index),
            );
          },
          onEditPressed: () async {
            final initParam = AddUpdateProductParam.fromProduct(data);
            log('initParam: $initParam');

            final editedProduct = await Navigator.of(context).push<ProductEntity>(
              MaterialPageRoute(
                builder: (context) {
                  return AddUpdateProductPage(initParam: initParam);
                },
              ),
            );

            if (editedProduct != null) {
              lazyController.updateAt(index, editedProduct);
            }
          },
        ),

        // separatorBuilder: (context, index) => const Divider(height: 0),
      ),
    );
  }
}

class VendorProductItem extends StatelessWidget {
  const VendorProductItem({
    super.key,
    required this.product,
    required this.onHidePressed,
    required this.onDeleteProduct,
    required this.onRestorePressed,
    required this.onEditPressed,
  });

  final ProductEntity product;
  final VoidCallback onHidePressed;
  final VoidCallback onDeleteProduct;
  final VoidCallback onRestorePressed;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          //# basic info
          Row(
            children: [
              //# image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),

              //# name + price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(product.name),
                    Text(
                      '${StringUtils.formatCurrency(product.minPrice)} - ${StringUtils.formatCurrency(product.maxPrice)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(indent: 12, endIndent: 12),
          //# other info (status, quantity stock (all variant), favorite count, sold)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // const Text('Yêu thích: xx'),
                    // rating
                    // Text('Rating: ${product.rating}'),
                    Rating(rating: double.tryParse(product.rating) ?? 0),
                    Text('Đã bán: ${product.sold}'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Text(product.status),
                    // Text('Số lượng: ${product.totalStock}'),

                    Text('Số lượng: ${product.totalStock}'),
                    Text(product.status),
                  ],
                ),
              ),
            ],
          ),

          //# action (change status)
          Row(
            children: [
              if (product.status == Status.ACTIVE.name || product.status == Status.INACTIVE.name) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: onHidePressed,
                    child: Text(product.status == Status.ACTIVE.name ? 'Ẩn' : 'Hiện'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onEditPressed,
                    child: const Text('Sửa'),
                  ),
                ),
              ] else if (product.status == Status.DELETED.name) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRestorePressed,
                    child: const Text('Khôi phục'),
                  ),
                ),
              ],

              // dropdown menu
              if (product.status == Status.ACTIVE.name || product.status == Status.INACTIVE.name) ...[
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'delete':
                        onDeleteProduct();
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Xóa'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
