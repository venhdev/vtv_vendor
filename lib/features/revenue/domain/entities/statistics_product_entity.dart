import 'dart:convert';

import 'package:vtv_common/home.dart';

class StatisticsProductEntity {
  final int totalSold;
  final int totalMoney;
  final ProductEntity product;

  StatisticsProductEntity({
    required this.totalSold,
    required this.totalMoney,
    required this.product,
  });

  StatisticsProductEntity copyWith({
    int? totalSold,
    int? totalMoney,
    ProductEntity? product,
  }) {
    return StatisticsProductEntity(
      totalSold: totalSold ?? this.totalSold,
      totalMoney: totalMoney ?? this.totalMoney,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalSold': totalSold,
      'totalMoney': totalMoney,
      'productDTO': product.toMap(),
    };
  }

  factory StatisticsProductEntity.fromMap(Map<String, dynamic> map) {
    return StatisticsProductEntity(
      totalSold: map['totalSold'] as int,
      totalMoney: map['totalMoney'] as int,
      product: ProductEntity.fromMap(map['productDTO'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsProductEntity.fromJson(String source) =>
      StatisticsProductEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StatisticsProductEntity(totalSold: $totalSold, totalMoney: $totalMoney, product: $product)';

  @override
  bool operator ==(covariant StatisticsProductEntity other) {
    if (identical(this, other)) return true;

    return other.totalSold == totalSold && other.totalMoney == totalMoney && other.product == product;
  }

  @override
  int get hashCode => totalSold.hashCode ^ totalMoney.hashCode ^ product.hashCode;
}
