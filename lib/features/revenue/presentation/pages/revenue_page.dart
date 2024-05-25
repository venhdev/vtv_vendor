import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../components/revenue_chart_by_status.dart';

class RevenuePage extends StatelessWidget {
  const RevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          RevenueByStatusItem(
            status: OrderStatus.COMPLETED,
            label: 'Thống kê đơn hàng hoàn thành',
          ),
          RevenueByStatusItem(
            status: OrderStatus.DELIVERED,
            label: 'Thống kê đơn hàng đã giao',
          ),
          RevenueByStatusItem(
            status: OrderStatus.SHIPPING,
            label: 'Thống kê đơn hàng đang giao',
          ),
          RevenueByStatusItem(
            status: OrderStatus.CANCEL,
            label: 'Thống kê đơn hàng bị hủy',
          ),
        ],
      ),
    );
  }
}

class RevenueByStatusItem extends StatefulWidget {
  const RevenueByStatusItem({
    super.key,
    required this.status,
    required this.label,
  });

  final OrderStatus status;
  final String label;

  @override
  State<RevenueByStatusItem> createState() => _RevenueByStatusItemState();
}

class _RevenueByStatusItemState extends State<RevenueByStatusItem> {
  int _selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      labelCrossAxisAlignment: CrossAxisAlignment.center,
      label: WrapperLabel(
        labelText: widget.label,
        icon: Icons.checklist_rounded,
        iconColor: Colors.green,
      ),
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
      child: RevenueChartByStatus(
        status: widget.status,
        byMonth: DateTime(DateTime.now().year, _selectedMonth),
      ),
    );
  }
}
