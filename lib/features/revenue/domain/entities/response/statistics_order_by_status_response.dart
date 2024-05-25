import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:vtv_common/core.dart';

import '../statistics_order_entity.dart';

class StatisticsOrderByStatusResp {
  final String status;
  final String message;
  final int code;
  final int count;
  final int totalOrder;
  final int totalMoney;
  final DateTime dateStart;
  final DateTime dateEnd;
  final List<StatisticsOrderEntity> statisticsOrders;

  StatisticsOrderByStatusResp({
    required this.status,
    required this.message,
    required this.code,
    required this.count,
    required this.totalOrder,
    required this.totalMoney,
    required this.dateStart,
    required this.dateEnd,
    required this.statisticsOrders,
  });

  int get maxOrder => statisticsOrders.map((e) => e.totalOrder).reduce((value, element) => value > element ? value : element);
  int get maxMoney => statisticsOrders.map((e) => e.totalMoney).reduce((value, element) => value > element ? value : element);
  int get totalDay => dateEnd.difference(dateStart).inDays + 1;
  int get avgMoneyPerDay => totalMoney ~/ totalDay;

  StatisticsOrderByStatusResp copyWith({
    String? status,
    String? message,
    int? code,
    int? count,
    int? totalOrder,
    int? totalMoney,
    DateTime? dateStart,
    DateTime? dateEnd,
    List<StatisticsOrderEntity>? statisticsOrders,
  }) {
    return StatisticsOrderByStatusResp(
      status: status ?? this.status,
      message: message ?? this.message,
      code: code ?? this.code,
      count: count ?? this.count,
      totalOrder: totalOrder ?? this.totalOrder,
      totalMoney: totalMoney ?? this.totalMoney,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      statisticsOrders: statisticsOrders ?? this.statisticsOrders,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'code': code,
      'count': count,
      'totalOrder': totalOrder,
      'totalMoney': totalMoney,
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'statisticsOrderDTOs': statisticsOrders.map((x) => x.toMap()).toList(),
    };
  }

  factory StatisticsOrderByStatusResp.fromMap(Map<String, dynamic> map) {
    return StatisticsOrderByStatusResp(
      status: map['status'] as String,
      message: map['message'] as String,
      code: map['code'] as int,
      count: map['count'] as int,
      totalOrder: map['totalOrder'] as int,
      totalMoney: map['totalMoney'] as int,
      dateStart: DateTimeUtils.tryParseLocal(map['dateStart'] as String)!,
      dateEnd: DateTimeUtils.tryParseLocal(map['dateEnd'] as String)!,
      statisticsOrders: List<StatisticsOrderEntity>.from((map['statisticsOrderDTOs'] as List).map<StatisticsOrderEntity>((x) => StatisticsOrderEntity.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsOrderByStatusResp.fromJson(String source) => StatisticsOrderByStatusResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatisticsOrderByStatus(status: $status, message: $message, code: $code, count: $count, totalOrder: $totalOrder, totalMoney: $totalMoney, dateStart: $dateStart, dateEnd: $dateEnd, statisticsOrderDTOs: $statisticsOrders)';
  }

  @override
  bool operator ==(covariant StatisticsOrderByStatusResp other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.status == status &&
      other.message == message &&
      other.code == code &&
      other.count == count &&
      other.totalOrder == totalOrder &&
      other.totalMoney == totalMoney &&
      other.dateStart == dateStart &&
      other.dateEnd == dateEnd &&
      listEquals(other.statisticsOrders, statisticsOrders);
  }

  @override
  int get hashCode {
    return status.hashCode ^
      message.hashCode ^
      code.hashCode ^
      count.hashCode ^
      totalOrder.hashCode ^
      totalMoney.hashCode ^
      dateStart.hashCode ^
      dateEnd.hashCode ^
      statisticsOrders.hashCode;
  }
}
