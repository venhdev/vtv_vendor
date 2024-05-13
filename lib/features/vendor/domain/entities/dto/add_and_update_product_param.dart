// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vtv_common/core.dart';

import 'product_variant_request.dart';

class AddUpdateProductParam {
  final int? productId;
  final String name;
  final String? image;
  final bool changeImage;
  final String description;
  final String information;
  final int categoryId;
  final int? brandId;
  final List<ProductVariantRequest> productVariantRequests;

 const AddUpdateProductParam({
    this.productId,
    required this.name,
    this.image,
    required this.changeImage,
    required this.description,
    required this.information,
    required this.categoryId,
    this.brandId,
    required this.productVariantRequests,
  });

  // AddUpdateProductParam copyWith({
  //   int? productId,
  //   String? name,
  //   String? image,
  //   bool? changeImage,
  //   String? description,
  //   String? information,
  //   int? categoryId,
  //   int? brandId,
  //   List<ProductVariantRequest>? productVariantRequests,
  // }) {
  //   return AddUpdateProductParam(
  //     productId: productId ?? this.productId,
  //     name: name ?? this.name,
  //     image: image ?? this.image,
  //     changeImage: changeImage ?? this.changeImage,
  //     description: description ?? this.description,
  //     information: information ?? this.information,
  //     categoryId: categoryId ?? this.categoryId,
  //     brandId: brandId ?? this.brandId,
  //     productVariantRequests: productVariantRequests ?? this.productVariantRequests,
  //   );
  // }

  Future<Map<String, dynamic>> toMap() async {
    return <String, dynamic>{
      'productId': productId,
      'name': name,
      if (image != null) 'image': await FileUtils.getMultiPartFileViaPath(image!),
      'changeImage': changeImage,
      'description': description,
      'information': information,
      'categoryId': categoryId,
      'brandId': brandId,
      // 'productVariantRequests': [
      //   // for (var item in productVariantRequests) await item.toMap(),
      // ],
    };
  }

  Future<Map<String, dynamic>> toMapWithVariants() async {
    final baseMap = await toMap();
    baseMap.addEntries([
      MapEntry('productVariantRequests', await Future.wait(productVariantRequests.map((e) async => await e.toMap()))),
    ]);
    return baseMap;
  }

  // factory AddAndUpdateProductParam.fromMap(Map<String, dynamic> map) {
  //   return AddAndUpdateProductParam(
  //     productId: map['productId'] as int,
  //     name: map['name'] as String,
  //     image: map['image'] != null ? map['image'] as String : null,
  //     changeImage: map['changeImage'] as bool,
  //     description: map['description'] as String,
  //     information: map['information'] as String,
  //     categoryId: map['categoryId'] as int,
  //     brandId: map['brandId'] != null ? map['brandId'] as int : null,
  //     productVariantRequests: List<ProductVariantRequest>.from(
  //       (map['productVariantRequests'] as List<int>).map<ProductVariantRequest>(
  //         (x) => ProductVariantRequest.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory AddAndUpdateProductParam.fromJson(String source) =>
  //     AddAndUpdateProductParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddAndUpdateProductParam(productId: $productId, name: $name, image: $image, changeImage: $changeImage, description: $description, information: $information, categoryId: $categoryId, brandId: $brandId, productVariantRequests: $productVariantRequests)';
  }

  @override
  bool operator ==(covariant AddUpdateProductParam other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.name == name &&
        other.image == image &&
        other.changeImage == changeImage &&
        other.description == description &&
        other.information == information &&
        other.categoryId == categoryId &&
        other.brandId == brandId &&
        listEquals(other.productVariantRequests, productVariantRequests);
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        name.hashCode ^
        image.hashCode ^
        changeImage.hashCode ^
        description.hashCode ^
        information.hashCode ^
        categoryId.hashCode ^
        brandId.hashCode ^
        productVariantRequests.hashCode;
  }

  AddUpdateProductParam copyWith({
    int? productId,
    String? name,
    String? image,
    bool? changeImage,
    String? description,
    String? information,
    int? categoryId,
    int? brandId,
    List<ProductVariantRequest>? productVariantRequests,
  }) {
    return AddUpdateProductParam(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      changeImage: changeImage ?? this.changeImage,
      description: description ?? this.description,
      information: information ?? this.information,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      productVariantRequests: productVariantRequests ?? this.productVariantRequests,
    );
  }
}
