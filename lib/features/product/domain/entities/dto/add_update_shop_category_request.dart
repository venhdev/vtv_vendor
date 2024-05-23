import 'dart:convert';

import 'package:vtv_common/core.dart';

class AddUpdateShopCategoryRequest {
  final String name;
  final bool changeImage;
  final String? image;

  AddUpdateShopCategoryRequest._({
    required this.name,
    required this.changeImage,
    required this.image,
  });

  AddUpdateShopCategoryRequest.updateFrom({
    required this.name,
    required this.changeImage,
    required this.image,
  });

  AddUpdateShopCategoryRequest.addInit({
    this.name = '',
  })  : changeImage = true,
        image = null;

  AddUpdateShopCategoryRequest copyWith({
    String? name,
    bool? changeImage,
    String? image,
  }) {
    return AddUpdateShopCategoryRequest._(
      name: name ?? this.name,
      changeImage: changeImage ?? this.changeImage,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'changeImage': changeImage,
      'image': image,
    };
  }

  Future<Map<String, dynamic>> toMultiPartFileMap() async {
    return <String, dynamic>{
      'name': name,
      'changeImage': changeImage,
      if (image != null && changeImage) 'image': await FileUtils.getMultiPartFileViaPath(image!),
    };
  }

  // factory AddUpdateCategoryRequest.fromMap(Map<String, dynamic> map) {
  //   return AddUpdateCategoryRequest(
  //     name: map['name'] as String,
  //     changeImage: map['changeImage'] as bool,
  //     image: map['image'] as String,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory AddUpdateCategoryRequest.fromJson(String source) =>
  //     AddUpdateCategoryRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddUpdateCategoryRequest(name: $name, changeImage: $changeImage, image: $image)';

  @override
  bool operator ==(covariant AddUpdateShopCategoryRequest other) {
    if (identical(this, other)) return true;

    return other.name == name && other.changeImage == changeImage && other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ changeImage.hashCode ^ image.hashCode;
}
