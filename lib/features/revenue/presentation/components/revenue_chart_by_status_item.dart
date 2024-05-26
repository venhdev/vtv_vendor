import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../components/revenue_chart_by_status.dart';

class RevenueChartByStatusItem extends StatefulWidget {
  const RevenueChartByStatusItem({
    super.key,
    required this.status,
    required this.label,
  });

  final OrderStatus status;
  final String label;

  @override
  State<RevenueChartByStatusItem> createState() => _RevenueChartByStatusItemState();
}

class _RevenueChartByStatusItemState extends State<RevenueChartByStatusItem> {
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
