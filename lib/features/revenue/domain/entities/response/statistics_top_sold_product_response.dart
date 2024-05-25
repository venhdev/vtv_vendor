// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:vtv_common/core.dart';

import '../statistics_product_entity.dart';

class StatisticsTopSoldProductResp {
  final int count;
  final int totalOrder;
  final int totalMoney;
  final int totalSold;
  final DateTime dateStart;
  final DateTime dateEnd;
  final List<StatisticsProductEntity> statisticsProducts;

  StatisticsTopSoldProductResp({
    required this.count,
    required this.totalOrder,
    required this.totalMoney,
    required this.totalSold,
    required this.dateStart,
    required this.dateEnd,
    required this.statisticsProducts,
  });

  StatisticsTopSoldProductResp copyWith({
    int? count,
    int? totalOrder,
    int? totalMoney,
    int? totalSold,
    DateTime? dateStart,
    DateTime? dateEnd,
    List<StatisticsProductEntity>? statisticsProducts,
  }) {
    return StatisticsTopSoldProductResp(
      count: count ?? this.count,
      totalOrder: totalOrder ?? this.totalOrder,
      totalMoney: totalMoney ?? this.totalMoney,
      totalSold: totalSold ?? this.totalSold,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      statisticsProducts: statisticsProducts ?? this.statisticsProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'totalOrder': totalOrder,
      'totalMoney': totalMoney,
      'totalSold': totalSold,
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'statisticsProductDTOs': statisticsProducts.map((x) => x.toMap()).toList(),
    };
  }

  factory StatisticsTopSoldProductResp.fromMap(Map<String, dynamic> map) {
    return StatisticsTopSoldProductResp(
      count: map['count'] as int,
      totalOrder: map['totalOrder'] as int,
      totalMoney: map['totalMoney'] as int,
      totalSold: map['totalSold'] as int,
      dateStart: DateTimeUtils.tryParseLocal(map['dateStart'] as String)!,
      dateEnd: DateTimeUtils.tryParseLocal(map['dateEnd'] as String)!,
      statisticsProducts: List<StatisticsProductEntity>.from(
        (map['statisticsProductDTOs'] as List).map<StatisticsProductEntity>(
          (x) => StatisticsProductEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsTopSoldProductResp.fromJson(String source) =>
      StatisticsTopSoldProductResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatisticsTopSoldProductResponse(count: $count, totalOrder: $totalOrder, totalMoney: $totalMoney, totalSold: $totalSold, dateStart: $dateStart, dateEnd: $dateEnd, statisticsProductDTOs: $statisticsProducts)';
  }

  @override
  bool operator ==(covariant StatisticsTopSoldProductResp other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.count == count &&
        other.totalOrder == totalOrder &&
        other.totalMoney == totalMoney &&
        other.totalSold == totalSold &&
        other.dateStart == dateStart &&
        other.dateEnd == dateEnd &&
        listEquals(other.statisticsProducts, statisticsProducts);
  }

  @override
  int get hashCode {
    return count.hashCode ^
        totalOrder.hashCode ^
        totalMoney.hashCode ^
        totalSold.hashCode ^
        dateStart.hashCode ^
        dateEnd.hashCode ^
        statisticsProducts.hashCode;
  }
}
