import 'package:dio/dio.dart';
import 'package:vendor/core/constants/vendor_api.dart';
import 'package:vtv_common/core.dart';

import '../../domain/entities/response/statistics_order_by_status_response.dart';
import '../../domain/entities/response/statistics_top_sold_product_response.dart';

abstract class RevenueDataSource {
  // revenue-shop-controller
  // GET
  // /api/vendor/shop/revenue/statistics/status/{status}
  // const String kAPIRevenueStatisticsByStatusURL = '/vendor/shop/revenue/statistics/status/:status'; // {status}
  // GET
  // /api/vendor/shop/revenue/statistics/product/top/{limit}
  // const String kAPIRevenueStatisticsProductTopURL = '/vendor/shop/revenue/statistics/product/top/:limit'; // {limit}

  //# revenue-shop-controller
  Future<SuccessResponse<StatisticsOrderByStatusResp>> statisticsByStatus(
      OrderStatus status, DateTime startDate, DateTime endDate);
  Future<SuccessResponse<StatisticsTopSoldProductResp>> statisticsProductTop(int limit, DateTime startDate, DateTime endDate);
}

class RevenueDataSourceImpl implements RevenueDataSource {
  final Dio _dio;

  RevenueDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<StatisticsOrderByStatusResp>> statisticsByStatus(
      OrderStatus status, DateTime startDate, DateTime endDate) async {
    final url = uriBuilder(
      path: kAPIRevenueStatisticsByStatusURL,
      pathVariables: {'status': status.name},
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<StatisticsOrderByStatusResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => StatisticsOrderByStatusResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<StatisticsTopSoldProductResp>> statisticsProductTop(int limit, DateTime startDate, DateTime endDate) async {
    final url = uriBuilder(
      path: kAPIRevenueStatisticsProductTopURL,
      pathVariables: {'limit': limit.toString()},
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<StatisticsTopSoldProductResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => StatisticsTopSoldProductResp.fromMap(jsonMap),
    );
  }
}
