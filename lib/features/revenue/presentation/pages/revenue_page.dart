import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../components/revenue_chart_by_status_item.dart';
import '../components/revenue_chart_by_top_sold.dart';

class RevenuePage extends StatelessWidget {
  const RevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          RevenueChartByTopSoldItem(),
          Divider(),
          RevenueChartByStatusItem(
            status: OrderStatus.COMPLETED,
            label: 'Thống kê đơn hàng hoàn thành',
          ),
          RevenueChartByStatusItem(
            status: OrderStatus.DELIVERED,
            label: 'Thống kê đơn hàng đã giao',
          ),
          RevenueChartByStatusItem(
            status: OrderStatus.SHIPPING,
            label: 'Thống kê đơn hàng đang giao',
          ),
          RevenueChartByStatusItem(
            status: OrderStatus.CANCEL,
            label: 'Thống kê đơn hàng bị hủy',
          ),
        ],
      ),
    );
  }
}

class RevenueChartByTopSoldItem extends StatefulWidget {
  const RevenueChartByTopSoldItem({
    super.key,
  });

  @override
  State<RevenueChartByTopSoldItem> createState() => _RevenueChartByTopSoldItemState();
}

class _RevenueChartByTopSoldItemState extends State<RevenueChartByTopSoldItem> {
  int _selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      suffixLabel: DropdownButton<int>(
        value: _selectedMonth,
        items: List.generate(12, (index) {
          return DropdownMenuItem<int>(
            value: index + 1,
            child: Text('Tháng ${index + 1}'),
          );
        }),
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _selectedMonth = value;
          });
        },
      ),
      child: RevenueChartByTopSold(limit: 10, byMonth: DateTime(DateTime.now().year, _selectedMonth)),
    );
  }
}
