import 'dart:convert';

import 'package:vtv_common/core.dart';

class StatisticsOrderEntity {
  final int totalMoney;
  final int totalOrder;
  final int totalProduct;
  final DateTime date;

  StatisticsOrderEntity({
    required this.totalMoney,
    required this.totalOrder,
    required this.totalProduct,
    required this.date,
  });

  StatisticsOrderEntity copyWith({
    int? totalMoney,
    int? totalOrder,
    int? totalProduct,
    DateTime? date,
  }) {
    return StatisticsOrderEntity(
      totalMoney: totalMoney ?? this.totalMoney,
      totalOrder: totalOrder ?? this.totalOrder,
      totalProduct: totalProduct ?? this.totalProduct,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalMoney': totalMoney,
      'totalOrder': totalOrder,
      'totalProduct': totalProduct,
      'date': date.toIso8601String(),
    };
  }

  factory StatisticsOrderEntity.fromMap(Map<String, dynamic> map) {
    return StatisticsOrderEntity(
      totalMoney: map['totalMoney'] as int,
      totalOrder: map['totalOrder'] as int,
      totalProduct: map['totalProduct'] as int,
      date: DateTimeUtils.tryParseLocal(map['date'] as String)!,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsOrderEntity.fromJson(String source) =>
      StatisticsOrderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatisticsOrderEntity(totalMoney: $totalMoney, totalOrder: $totalOrder, totalProduct: $totalProduct, date: $date)';
  }

  @override
  bool operator ==(covariant StatisticsOrderEntity other) {
    if (identical(this, other)) return true;

    return other.totalMoney == totalMoney &&
        other.totalOrder == totalOrder &&
        other.totalProduct == totalProduct &&
        other.date == date;
  }

  @override
  int get hashCode {
    return totalMoney.hashCode ^ totalOrder.hashCode ^ totalProduct.hashCode ^ date.hashCode;
  }
}
