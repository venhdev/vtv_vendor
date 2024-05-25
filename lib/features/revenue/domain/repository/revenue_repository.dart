import 'package:vtv_common/core.dart';

import '../../data/datasources/revenue_data_source.dart';
import '../entities/response/statistics_order_by_status_response.dart';
import '../entities/response/statistics_top_sold_product_response.dart';

abstract class RevenueRepository {
  //# revenue-shop-controller
  FRespData<StatisticsOrderByStatusResp> getStatisticsByStatus(
      OrderStatus status, DateTime startDate, DateTime endDate);
  FRespData<StatisticsTopSoldProductResp> getStatisticsProductTop(int limit, DateTime startDate, DateTime endDate);
}

class RevenueRepositoryImpl implements RevenueRepository {
  RevenueRepositoryImpl(this._dataSource);

  final RevenueDataSource _dataSource;

  @override
  FRespData<StatisticsOrderByStatusResp> getStatisticsByStatus(
      OrderStatus status, DateTime startDate, DateTime endDate) async {
    return await handleDataResponseFromDataSource(
        dataCallback: () => _dataSource.statisticsByStatus(status, startDate, endDate));
  }

  @override
  FRespData<StatisticsTopSoldProductResp> getStatisticsProductTop(
      int limit, DateTime startDate, DateTime endDate) async {
    return await handleDataResponseFromDataSource(
        dataCallback: () => _dataSource.statisticsProductTop(limit, startDate, endDate));
  }
}
