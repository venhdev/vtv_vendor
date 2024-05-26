import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../../domain/entities/statistics_product_entity.dart';

class TopSoldItem extends StatelessWidget {
  const TopSoldItem({super.key, required this.productStats});

  final StatisticsProductEntity productStats;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(productStats.product.image)),
      title: Text(productStats.product.name),
      subtitle: Text('Số lượng bán: ${productStats.totalSold}'),
      trailing: Text('Tổng tiền:\n${ConversionUtils.formatCurrency(productStats.totalMoney)}'),
    );
  }
}
