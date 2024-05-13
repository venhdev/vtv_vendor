import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vtv_common/core.dart';

import 'product_attribute_request.dart';

class ProductVariantRequest {
  final int? productVariantId;
  final String sku;
  final String? image;
  final bool changeImage;
  final int originalPrice;
  final int price;
  final int quantity;
  final List<ProductAttributeRequest> productAttributeRequests;

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
  //! for add/update variant
  String get attributeIdentifier {
    if (productAttributeRequests.isEmpty) return sku;
    return productAttributeRequests.map((e) => e.value).join(', ');
  }

  bool isValid({bool imageRequired = true, bool hasAttribute = true}) {
    if (sku.isEmpty) {
      return false;
    }
    if (imageRequired && image == null) {
      return false;
    }
    if (originalPrice <= 0) {
      return false;
    }
    if (price <= 0) {
      return false;
    }
    if (quantity <= 0) {
      return false;
    }
    if (hasAttribute && productAttributeRequests.isEmpty) {
      return false;
    }
    return true;
  }

  String isValidMessage({bool imageRequired = true, bool hasAttribute = true}) {
    if (sku.isEmpty) {
      return 'SKU không hợp lệ';
    }
    if (imageRequired && image == null) {
      return 'ảnh không hợp lệ';
    }
    if (originalPrice <= 0) {
      return 'giá gốc không hợp lệ';
    }
    if (price <= 0) {
      return 'giá bán không hợp lệ';
    }
    if (quantity <= 0) {
      return 'số lượng không hợp lệ';
    }
    if (hasAttribute && productAttributeRequests.isEmpty) {
      return 'thuộc tính không hợp lệ';
    }
    return '';
  }

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

  Future<String> toJson() async => json.encode(await toMap());

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
