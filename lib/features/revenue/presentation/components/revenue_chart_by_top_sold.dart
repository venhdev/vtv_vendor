import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/response/statistics_top_sold_product_response.dart';
import '../../domain/repository/revenue_repository.dart';
import 'top_sold_item.dart';

class RevenueChartByTopSold extends StatelessWidget {
  const RevenueChartByTopSold({super.key, required this.limit, this.byMonth, this.startDate, this.endDate});

  final int limit;
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
        future: sl<RevenueRepository>().getStatisticsProductTop(limit, start, end),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final respEither = snapshot.data!;
            return respEither.fold(
              (error) => MessageScreen.error(error.message),
              (ok) {
                if (ok.data!.totalMoney == 0 && ok.data!.totalOrder == 0) {
                  return MessageScreen(message: 'Chưa có dữ liệu thống kê', textStyle: VTVTheme.hintTextStyle);
                }

                return Column(
                  children: [
                    RevenueByTopSoldPieChart(data: ok.data!),
                    for (var i = 0; i < ok.data!.statisticsProducts.length; i++)
                      TopSoldItem(productStats: ok.data!.statisticsProducts[i]),
                  ],
                );
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

class RevenueByTopSoldPieChart extends StatefulWidget {
  const RevenueByTopSoldPieChart({super.key, required this.data, this.height = 400.0});

  final StatisticsTopSoldProductResp data;
  final double height;

  @override
  State<RevenueByTopSoldPieChart> createState() => _RevenueByTopSoldPieChartState();
}

class _RevenueByTopSoldPieChartState extends State<RevenueByTopSoldPieChart> {
  // int touchedIndex = 0;

  final List<Color> _getColors = [
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PieChart(
        PieChartData(
            // pieTouchData: PieTouchData(
            //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
            //     setState(() {
            //       if (!event.isInterestedForInteractions ||
            //           pieTouchResponse == null ||
            //           pieTouchResponse.touchedSection == null) {
            //         touchedIndex = -1;
            //         return;
            //       }
            //       touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            //       log('touchedIndex: $touchedIndex');
            //     });
            //   },
            // ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            // sections: widget.data.statisticsProducts.map((e) => PieChartSectionData()).toList(),
            sections: <PieChartSectionData>[
              for (var i = 0; i < widget.data.statisticsProducts.length; i++)
                PieChartSectionData(
                  color: _getColors[i],
                  value: widget.data.statisticsProducts[i].totalSold.toDouble(),
                  title: '${widget.data.statisticsProducts[i].totalSold}',
                  // radius: i == touchedIndex ? 110 : 100,
                  radius: 150,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  badgeWidget: _Badge(
                    widget.data.statisticsProducts[i].product.image,
                    size: 40,
                    borderColor: Colors.black,
                  ),
                  badgePositionPercentageOffset: .98,
                ),
            ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.image, {
    required this.size,
    required this.borderColor,
  });
  final String image;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .05),
      child: CircleAvatar(backgroundImage: NetworkImage(image)),
    );
  }
}
