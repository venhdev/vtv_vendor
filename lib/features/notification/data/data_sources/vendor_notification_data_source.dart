import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../core/constants/vendor_api.dart';

abstract class VendorNotificationDataSource {
  Future<SuccessResponse<NotificationPageResp>> getPageNotifications(int page, int size);
  Future<SuccessResponse<NotificationPageResp>> markAsRead(String id);
  Future<SuccessResponse<NotificationPageResp>> deleteNotification(String id);
}

class VendorNotificationDataSourceImpl implements VendorNotificationDataSource {
  VendorNotificationDataSourceImpl(
    this._dio,
  );

  final Dio _dio;

  @override
  Future<SuccessResponse<NotificationPageResp>> getPageNotifications(int page, int size) async {
    final url = uriBuilder(
      path: kAPINotificationGetPageURL,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
      },
    );

    final Response response = await _dio.getUri(
      url,
    );

    return handleDioResponse<NotificationPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationPageResp.fromMap(dataMap),
    );
  }

  @override
  Future<SuccessResponse<NotificationPageResp>> markAsRead(String id) async {
    final url = uriBuilder(
      path: '$kAPINotificationReadURL/$id',
    );

    final Response response = await _dio.putUri(
      url,
    );

    return handleDioResponse<NotificationPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationPageResp.fromMap(dataMap),
    );
  }

  @override
  Future<SuccessResponse<NotificationPageResp>> deleteNotification(String id) async {
    final url = uriBuilder(
      path: '$kAPINotificationDeleteURL/$id',
    );

    final Response response = await _dio.deleteUri(
      url,
    );

    return handleDioResponse<NotificationPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationPageResp.fromMap(dataMap),
    );
  }
}
