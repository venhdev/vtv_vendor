import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/vendor_notification_repository.dart';

const int _notificationPerPage = 20;
//! this page is a copy of notification_page.dart (flutter vtv)
class VendorNotificationPage extends StatefulWidget {
  const VendorNotificationPage({super.key});

  @override
  State<VendorNotificationPage> createState() => _VendorNotificationPageState();
}

class _VendorNotificationPageState extends State<VendorNotificationPage> {
  late LazyLoadController<NotificationEntity> controller;

  @override
  void initState() {
    super.initState();
    controller = LazyLoadController<NotificationEntity>(
      items: [],
      scrollController: ScrollController(),
      useGrid: false,
      emptyMessage: 'Không có thông báo nào',
    );
  }
  // static const String routeRoot = '/notification';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationList(
        dataCallback: (page) => sl<VendorNotificationRepository>().getPageNotifications(page, _notificationPerPage),
        markAsRead: (id) async {
          final resultEither = await sl<VendorNotificationRepository>().markAsRead(id);

          resultEither.fold(
            (error) {
              Fluttertoast.showToast(msg: '${error.message}');
            },
            (ok) {
              controller.reload(newItems: ok.data!.items);
            },
          );
        },
        deleteNotification: (id, index) async {
          final resultEither = await sl<VendorNotificationRepository>().deleteNotification(id);

          return resultEither.fold(
            (error) {
              return false;
            },
            (ok) {
              controller.removeAt(index);
              return true;
            },
          );
        },
      ),
    );
  }
}
