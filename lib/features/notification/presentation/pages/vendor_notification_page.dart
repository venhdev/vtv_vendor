import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../core/handler/vendor_handler.dart';
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
  late LazyListController<NotificationEntity> _lazyListController;

  @override
  void initState() {
    super.initState();
    _lazyListController = LazyListController<NotificationEntity>.sliver(
      paginatedData: (page) => sl<VendorNotificationRepository>().getPageNotifications(page, _notificationPerPage),
      items: [],
      scrollController: ScrollController(),
      itemBuilder: (_, index, data) => notificationItem(data, index),
      showLoadingIndicator: true,
    )..init();
  }

  NotificationItem notificationItem(NotificationEntity data, int index) {
    void handleRead() async {
      if (data.seen) return; // Already read
      final resultEither = await sl<VendorNotificationRepository>().markAsRead(data.notificationId);

      resultEither.fold(
        (error) {
          Fluttertoast.showToast(msg: '${error.message}');
        },
        (ok) {
          log('${ok.message}');
          _lazyListController.updateAt(index, data.copyWith(seen: true));
        },
      );
    }

    return NotificationItem(
      notification: data,
      onPressed: (notificationId) {
        handleRead();
        final uuid = ConversionUtils.extractUUID(data.body);
        if (uuid != null) VendorHandler.navigateToOrderDetailPage(context, orderId: uuid);
      },
      onExpandPressed: handleRead,
      onConfirmDismiss: (notificationId) async {
        final resultEither = await sl<VendorNotificationRepository>().deleteNotification(notificationId);

        return resultEither.fold(
          (error) {
            return false;
          },
          (ok) {
            log('${ok.message}');
            _lazyListController.removeAt(index);
            return true;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationList(lazyListController: _lazyListController),
    );
  }
}
