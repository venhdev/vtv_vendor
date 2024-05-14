// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vtv_common/home.dart';

class CategoryWithNestedChildrenEntity {
  const CategoryWithNestedChildrenEntity({
    required this.parent,
    required this.children,
  });

  final CategoryEntity parent;
  final List<CategoryEntity> children;

  CategoryWithNestedChildrenEntity copyWith({
    CategoryEntity? parent,
    List<CategoryEntity>? children,
  }) {
    return CategoryWithNestedChildrenEntity(
      parent: parent ?? this.parent,
      children: children ?? this.children,
    );
  }

  factory CategoryWithNestedChildrenEntity.fromMap(Map<String, dynamic> map) {
    return CategoryWithNestedChildrenEntity(
      parent: CategoryEntity.fromMap(map['parent'] as Map<String, dynamic>),
      children: List<CategoryEntity>.from(
        (map['children'] as List<dynamic>).map<CategoryEntity>(
          (x) => CategoryEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory CategoryWithNestedChildrenEntity.fromJson(String source) =>
      CategoryWithNestedChildrenEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryWithNestedChildrenEntity(parent: $parent, children: $children)';

  @override
  bool operator ==(covariant CategoryWithNestedChildrenEntity other) {
    if (identical(this, other)) return true;

    return other.parent == parent && listEquals(other.children, children);
  }

  @override
  int get hashCode => parent.hashCode ^ children.hashCode;
}
