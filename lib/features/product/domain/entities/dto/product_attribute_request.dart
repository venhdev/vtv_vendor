// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:vtv_common/home.dart';

class ProductAttributeRequest {
  final String name;
  final String value;

  const ProductAttributeRequest({
    required this.name,
    required this.value,
  });

  ProductAttributeRequest copyWith({
    String? name,
    String? value,
  }) {
    return ProductAttributeRequest(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'value': value,
    };
  }

  factory ProductAttributeRequest.fromProductAttribute(AttributeEntity attribute) {
    return ProductAttributeRequest(
      name: attribute.name,
      value: attribute.value,
    );
    // return ProductAttributeRequest(
    //   name: map['name'] as String,
    //   value: map['value'] as String,
    // );
  }

  String toJson() => json.encode(toMap());

  // factory ProductAttributeRequest.fromJson(String source) =>
  //     ProductAttributeRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductAttributeRequest(name: $name, value: $value)';

  @override
  bool operator ==(covariant ProductAttributeRequest other) {
    if (identical(this, other)) return true;

    return other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
