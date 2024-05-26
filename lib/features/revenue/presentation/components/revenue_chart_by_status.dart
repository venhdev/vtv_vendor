import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/response/statistics_order_by_status_response.dart';
import '../../domain/repository/revenue_repository.dart';

class RevenueChartByStatus extends StatelessWidget {
  const RevenueChartByStatus({super.key, required this.status, this.byMonth, this.startDate, this.endDate});

  final OrderStatus status;
  final DateTime? byMonth;

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    assert(
      byMonth != null || (startDate != null && endDate != null),
      'byMonth or startDate and endDate must not be null',
    );
    final DateTime start;
    final DateTime end;

    if (startDate != null && endDate != null) {
      start = startDate!;
      end = endDate!;
    } else {
      start = DateTimeUtils.firstDateOfMonth(byMonth!);
      end = DateTimeUtils.lastDateOfMonth(byMonth!);
    }

    return Center(
      child: FutureBuilder(
        future: sl<RevenueRepository>().getStatisticsByStatus(status, start, end),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final respEither = snapshot.data!;
            return respEither.fold(
              (error) => MessageScreen.error(error.message),
              (ok) {
                if (ok.data!.totalMoney == 0 && ok.data!.totalOrder == 0) {
                  return MessageScreen(message: 'Chưa có dữ liệu thống kê', textStyle: VTVTheme.hintTextStyle);
                }

                return RevenueByStatusLineChart(data: ok.data!);
              },
            );
          } else if (snapshot.hasError) {
            return MessageScreen.error(snapshot.error.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class RevenueByStatusLineChart extends StatefulWidget {
  const RevenueByStatusLineChart({super.key, required this.data, this.height = 400.0});

  final StatisticsOrderByStatusResp data;
  final double height;

  @override
  State<RevenueByStatusLineChart> createState() => _RevenueByStatusLineChartState();
}

class _RevenueByStatusLineChartState extends State<RevenueByStatusLineChart> {
  List<Color> gradientColors = [
    Colors.cyanAccent,
    Colors.blueAccent,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LineChart(showAvg ? avgData() : mainData()),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      titlesData: FlTitlesData(topTitles: getTopTitles()),
      minY: 0,
      maxY: ConversionUtils.ceilTo5FirstTwoDigits(widget.data.maxMoney.toDouble()).toDouble(),
      lineTouchData: LineTouchData(
        touchTooltipData: lineToucherToolTipData(),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: widget.data.statisticsOrders.map((e) {
            final x = e.date.day.toDouble();
            final y = e.totalMoney.toDouble();
            return FlSpot(x, y);
          }).toList(),
          // isCurved: true,
          // isStrokeCapRound: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(colors: gradientColors.map((color) => color.withOpacity(0.3)).toList()),
          ),
        ),
      ],
    );
  }

  int? getTotalOrderByDay(double date) {
    try {
      final order = widget.data.statisticsOrders.firstWhere((element) => element.date.day == date);
      return order.totalOrder;
    } on StateError {
      return null;
    }
  }

  LineTouchTooltipData lineToucherToolTipData() {
    return LineTouchTooltipData(
      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
        return touchedBarSpots.map((barSpot) {
          final total = getTotalOrderByDay(barSpot.x);
          return LineTooltipItem(
            // 'Ngày ${barSpot.x.toInt()}: ${ConversionUtils.formatCurrency(barSpot.y.toInt())}',
            'Ngày ${barSpot.x.toInt()}: ${ConversionUtils.formatCurrencyWithAbbreviation(barSpot.y, fraction: 1)}${(total != null && total != 0) ? '\n($total đơn)' : ''}',
            const TextStyle(color: Colors.white),
          );
        }).toList();
      },
    );
  } 

  LineChartData avgData() {
    return LineChartData(
      // minX: 1,
      // maxY: 1000000,
      minY: 0,
      maxY: ConversionUtils.ceilTo5FirstTwoDigits(widget.data.maxMoney.toDouble()).toDouble(),
      titlesData: FlTitlesData(
        topTitles: getTopTitles(),
      ),
      lineTouchData: const LineTouchData(enabled: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(widget.data.dateStart.day.toDouble(), widget.data.avgMoneyPerDay.toDouble()),
            FlSpot(widget.data.dateEnd.day.toDouble(), widget.data.avgMoneyPerDay.toDouble()),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AxisTitles getTopTitles() {
    return AxisTitles(
        axisNameWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trung bình doanh thu: ${ConversionUtils.formatCurrency(widget.data.avgMoneyPerDay)}',
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              onPressed: () => setState(() => showAvg = !showAvg),
              icon: Icon(showAvg ? Icons.bar_chart_rounded : Icons.show_chart_rounded, color: Colors.black),
            ),
          ],
        ),
        axisNameSize: 36);
  }
}
