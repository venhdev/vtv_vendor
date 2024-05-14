// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:vtv_common/home.dart';

class AddProductResp {
  final String status;
  final String message;
  final int code;
  final int categoryId;
  final String categoryName;
  final int? categoryParentId;
  final String? categoryParentName;
  final int shopId;
  final String shopName;
  final String shopAvatar;
  final int countOrder;
  final ProductEntity productDto;

  AddProductResp({
    required this.status,
    required this.message,
    required this.code,
    required this.categoryId,
    required this.categoryName,
    required this.categoryParentId,
    required this.categoryParentName,
    required this.shopId,
    required this.shopName,
    required this.shopAvatar,
    required this.countOrder,
    required this.productDto,
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
    ProductEntity? productDto,
  }) {
    return AddProductResp(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryParentId: categoryParentId ?? this.categoryParentId,
      categoryParentName: categoryParentName ?? this.categoryParentName,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopAvatar: shopAvatar ?? this.shopAvatar,
      countOrder: countOrder ?? this.countOrder,
      productDto: productDto ?? this.productDto,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'code': code,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryParentId': categoryParentId,
      'categoryParentName': categoryParentName,
      'shopId': shopId,
      'shopName': shopName,
      'shopAvatar': shopAvatar,
      'countOrder': countOrder,
      'productDto': productDto.toMap(),
    };
  }

  factory AddProductResp.fromMap(Map<String, dynamic> map) {
    return AddProductResp(
      status: map['status'] as String,
      message: map['message'] as String,
      code: map['code'] as int,
      categoryId: map['categoryId'] as int,
      categoryName: map['categoryName'] as String,
      categoryParentId: map['categoryParentId'] as int?,
      categoryParentName: map['categoryParentName'] as String?,
      shopId: map['shopId'] as int,
      shopName: map['shopName'] as String,
      shopAvatar: map['shopAvatar'] as String,
      countOrder: map['countOrder'] as int,
      productDto: ProductEntity.fromMap(map['productDTO'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddProductResp.fromJson(String source) => AddProductResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductAddResp(status: $status, message: $message, code: $code, categoryId: $categoryId, categoryName: $categoryName, categoryParentId: $categoryParentId, categoryParentName: $categoryParentName, shopId: $shopId, shopName: $shopName, shopAvatar: $shopAvatar, countOrder: $countOrder, productDto: $productDto)';
  }

  @override
  bool operator ==(covariant AddProductResp other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.message == message &&
        other.code == code &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.categoryParentId == categoryParentId &&
        other.categoryParentName == categoryParentName &&
        other.shopId == shopId &&
        other.shopName == shopName &&
        other.shopAvatar == shopAvatar &&
        other.countOrder == countOrder &&
        other.productDto == productDto;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        code.hashCode ^
        categoryId.hashCode ^
        categoryName.hashCode ^
        categoryParentId.hashCode ^
        categoryParentName.hashCode ^
        shopId.hashCode ^
        shopName.hashCode ^
        shopAvatar.hashCode ^
        countOrder.hashCode ^
        productDto.hashCode;
  }
}
