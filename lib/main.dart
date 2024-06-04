import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vendor/config/firebase_options.dart';
import 'package:vendor/service_locator.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/dev.dart';

import 'app_state.dart';
import 'core/constants/global_variables.dart';
import 'core/handler/vendor_handler.dart';
import 'vendor_app_scaffold.dart';

void main() async {
  // WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeLocator(); // dependency injection

  // get singleton instance from service locator
  final localNotificationHelper = sl<LocalNotificationHelper>();
  final authCubit = sl<AuthCubit>();
  await authCubit.onStarted();

  sl<FirebaseCloudMessagingManager>().requestPermission();
  sl<FirebaseCloudMessagingManager>().listen(
    onForegroundMessageReceived: (remoteMessage) {
      if (remoteMessage == null) return;

      //> should show new chat notification
      if (remoteMessage.type == NotificationType.NEW_MESSAGE.name &&
          GlobalVariables.currentChatRoomId == remoteMessage.data['roomChatId']) return;

      localNotificationHelper.showRemoteMessageNotification(remoteMessage);
    },
    onTapMessageOpenedApp: (remoteMessage) {
      if (remoteMessage != null) VendorHandler.processOpenRemoteMessage(remoteMessage);
    },
  );

  // handle show fcm foreground + nav to order detail
  localNotificationHelper.initializePluginAndHandler(onDidReceiveNotificationResponse: (notification) {
    //TODO server not contain notificationId >> cannot handle mark as read
    if (notification.payload == null) return;
    final RemoteMessage remoteMessage = RemoteMessageSerialization.fromJson(notification.payload!);
    VendorHandler.processOpenRemoteMessage(remoteMessage);
  });

  // NOTE: dev
  final savedHost = sl<SharedPreferencesHelper>().I.getString('host');
  if (savedHost != null) {
    host = savedHost;
  } else {
    final curHost = await DevUtils.initHostWithCurrentIPv4('192.168.1.100');
    if (curHost != null) {
      // host = curHost; //? already set in initHostWithCurrentIPv4
      sl<SharedPreferencesHelper>().I.setString('host', curHost);
    }
  }

  final appState = AppState(sl<Connectivity>())..init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => appState),
      BlocProvider(create: (_) => authCubit),
    ],
    child: const VendorApp(),
  ));
}
