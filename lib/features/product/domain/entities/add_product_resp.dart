import 'dart:convert';

import 'package:vtv_common/home.dart';

class AddProductResp {
  final int categoryId;
  final String categoryName;
  final int? categoryParentId;
  final String? categoryParentName;
  final int shopId;
  final String shopName;
  final String shopAvatar;
  final int countOrder;
  final ProductEntity product;

  AddProductResp({
    required this.categoryId,
    required this.categoryName,
    required this.categoryParentId,
    required this.categoryParentName,
    required this.shopId,
    required this.shopName,
    required this.shopAvatar,
    required this.countOrder,
    required this.product,
  });

  AddProductResp copyWith({
    String? status,
    String? message,
    int? code,
    int? categoryId,
    String? categoryName,
    int? categoryParentId,
    String? categoryParentName,
    int? shopId,
    String? shopName,
    String? shopAvatar,
    int? countOrder,
    ProductEntity? product,
  }) {
    return AddProductResp(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryParentId: categoryParentId ?? this.categoryParentId,
      categoryParentName: categoryParentName ?? this.categoryParentName,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopAvatar: shopAvatar ?? this.shopAvatar,
      countOrder: countOrder ?? this.countOrder,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryParentId': categoryParentId,
      'categoryParentName': categoryParentName,
      'shopId': shopId,
      'shopName': shopName,
      'shopAvatar': shopAvatar,
      'countOrder': countOrder,
      'productDto': product.toMap(),
    };
  }

  factory AddProductResp.fromMap(Map<String, dynamic> map) {
    return AddProductResp(
      categoryId: map['categoryId'] as int,
      categoryName: map['categoryName'] as String,
      categoryParentId: map['categoryParentId'] as int?,
      categoryParentName: map['categoryParentName'] as String?,
      shopId: map['shopId'] as int,
      shopName: map['shopName'] as String,
      shopAvatar: map['shopAvatar'] as String,
      countOrder: map['countOrder'] as int,
      product: ProductEntity.fromMap(map['productDTO'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddProductResp.fromJson(String source) => AddProductResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductAddResp(categoryId: $categoryId, categoryName: $categoryName, categoryParentId: $categoryParentId, categoryParentName: $categoryParentName, shopId: $shopId, shopName: $shopName, shopAvatar: $shopAvatar, countOrder: $countOrder, productDto: $product)';
  }

  @override
  bool operator ==(covariant AddProductResp other) {
    if (identical(this, other)) return true;

    return other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.categoryParentId == categoryParentId &&
        other.categoryParentName == categoryParentName &&
        other.shopId == shopId &&
        other.shopName == shopName &&
        other.shopAvatar == shopAvatar &&
        other.countOrder == countOrder &&
        other.product == product;
  }

  @override
  int get hashCode {
    return categoryId.hashCode ^
        categoryName.hashCode ^
        categoryParentId.hashCode ^
        categoryParentName.hashCode ^
        shopId.hashCode ^
        shopName.hashCode ^
        shopAvatar.hashCode ^
        countOrder.hashCode ^
        product.hashCode;
  }
}
