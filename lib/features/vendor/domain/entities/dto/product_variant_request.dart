// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vtv_common/core.dart';

import 'product_attribute_request.dart';

class ProductVariantRequest {
  int? productVariantId;
  String sku;
  String? image;
  bool changeImage;
  int originalPrice;
  int price;
  int quantity;
  List<ProductAttributeRequest> productAttributeRequests;

  ProductVariantRequest({
    this.productVariantId,
    required this.sku,
    required this.image,
    required this.changeImage,
    required this.originalPrice,
    required this.price,
    required this.quantity,
    required this.productAttributeRequests,
  });

  ProductVariantRequest copyWith({
    int? productVariantId,
    String? sku,
    String? image,
    bool? changeImage,
    int? originalPrice,
    int? price,
    int? quantity,
    List<ProductAttributeRequest>? productAttributeRequests,
  }) {
    return ProductVariantRequest(
      productVariantId: productVariantId ?? this.productVariantId,
      sku: sku ?? this.sku,
      image: image ?? this.image,
      changeImage: changeImage ?? this.changeImage,
      originalPrice: originalPrice ?? this.originalPrice,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productAttributeRequests: productAttributeRequests ?? this.productAttributeRequests,
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    return <String, dynamic>{
      'productVariantId': productVariantId,
      'sku': sku,
      if (image != null) 'image': await FileUtils.getMultiPartFileViaPath(image!),
      'changeImage': changeImage,
      'originalPrice': originalPrice,
      'price': price,
      'quantity': quantity,
      // 'productAttributeRequests': productAttributeRequests.map((x) => x.toMap()).toList(),
      'productAttributeRequests': [for (var item in productAttributeRequests) item.toMap()]
    };
  }

  // factory ProductVariantRequest.fromMap(Map<String, dynamic> map) {
  //   return ProductVariantRequest(
  //     productVariantId: map['productVariantId'] as int,
  //     sku: map['sku'] as String,
  //     image: map['image'] as String,
  //     changeImage: map['changeImage'] as bool,
  //     originalPrice: map['originalPrice'] as int,
  //     price: map['price'] as int,
  //     quantity: map['quantity'] as int,
  //     productAttributeRequests: List<ProductAttributeRequest>.from(
  //       (map['productAttributeRequests'] as List<int>).map<ProductAttributeRequest>(
  //         (x) => ProductAttributeRequest.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //   );
  // }

  Future<String> toJson() async => json.encode(await toMap());

  // factory ProductVariantRequest.fromJson(String source) =>
  //     ProductVariantRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductVariantRequest(productVariantId: $productVariantId, sku: $sku, image: $image, changeImage: $changeImage, originalPrice: $originalPrice, price: $price, quantity: $quantity, productAttributeRequests: $productAttributeRequests)';
  }

  @override
  bool operator ==(covariant ProductVariantRequest other) {
    if (identical(this, other)) return true;

    return other.productVariantId == productVariantId &&
        other.sku == sku &&
        other.image == image &&
        other.changeImage == changeImage &&
        other.originalPrice == originalPrice &&
        other.price == price &&
        other.quantity == quantity &&
        listEquals(other.productAttributeRequests, productAttributeRequests);
  }

  @override
  int get hashCode {
    return productVariantId.hashCode ^
        sku.hashCode ^
        image.hashCode ^
        changeImage.hashCode ^
        originalPrice.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        productAttributeRequests.hashCode;
  }
}
