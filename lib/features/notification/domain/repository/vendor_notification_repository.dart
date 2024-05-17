import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

abstract class VendorNotificationRepository {
  FRespData<NotificationPageResp> getPageNotifications(int page, int size);
  FRespData<NotificationPageResp> markAsRead(String id);
  FRespData<NotificationPageResp> deleteNotification(String id);
}
