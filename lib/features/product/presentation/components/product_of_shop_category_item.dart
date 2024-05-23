import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

class ProductOfShopCategoryItem extends StatelessWidget {
  const ProductOfShopCategoryItem({super.key, required this.product, this.onPressed, this.onLongPress});

  final ProductEntity product;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      onLongPress: onLongPress,
      leading: CircleAvatar(radius: 20, child: ImageCacheable(product.image)),
      title: Text(product.name),
    );
  }
}
