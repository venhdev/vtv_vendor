import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';

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
  final authCubit = sl<AuthCubit>()..onStarted();

  sl<FirebaseCloudMessagingManager>().requestPermission();
  sl<FirebaseCloudMessagingManager>().listenToIncomingMessageAndHandleTap(
    onForegroundMessageReceived: (remoteMessage) {
      if (remoteMessage == null) return;
      localNotificationHelper.showRemoteMessageNotification(remoteMessage);
    },
    onTapMessageOpenedApp: (remoteMessage) {
      log('onTapMessageOpenedApp: $remoteMessage');
      VendorHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
    },
    onTapMessageTerminatedApp: (remoteMessage) {
      log('onTapMessageTerminatedApp: $remoteMessage');
      VendorHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
    },
  );

  // handle show fcm foreground + nav to order detail
  localNotificationHelper.initializePluginAndHandler(onDidReceiveNotificationResponse: (notification) {
    //TODO server not contain notificationId >> cannot handle mark as read
    if (notification.payload == null) return;
    final RemoteMessage remoteMessage = RemoteMessageSerialization.fromJson(notification.payload!);
    VendorHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
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

  runApp(MultiProvider(
    providers: [
      BlocProvider(create: (context) => authCubit),
    ],
    child: const VendorApp(),
  ));

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // final LocalNotificationHelper localNotificationHelper = LocalNotificationHelper(
  //   FlutterLocalNotificationsPlugin(),
  //   onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
  //   onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponse,
  // )..init();

  // final FirebaseMessaging firebaseMessaging = sl<FirebaseCloudMessagingManager>().I;

  // FirebaseCloudMessagingManager(firebaseMessaging).listenToIncomingMessageAndHandleTap(
  //   onTapMessageOpenedApp: (msg) {
  //     if (msg == null) return;
  //     GlobalVariables.navigatorState.currentState!.pushReplacementNamed('/message', arguments: msg.data.toString());
  //   },
  //   onForegroundMessageReceived: (msg) {
  //     if (msg == null || msg.notification == null) return;

  //     sl<LocalNotificationHelper>().showNotification(
  //       id: Random().nextInt(1000),
  //       title: msg.notification!.title ?? '',
  //       body: msg.notification!.body ?? '',
  //       notificationChannel: AppNotificationChannels.defaultImportanceChannel,
  //     );
  //   },
  // );

  // runApp(const TestApp());
}

// class TestApp extends StatelessWidget {
//   const TestApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Test App',
//       navigatorKey: GlobalVariables.navigatorState,
//       home: const HomeScreen(),
//       routes: {
//         '/message': (context) {
//           final message = ModalRoute.of(context)?.settings.arguments as String;
//           return MessageScreen(message: message);
//         },
//         '/page2': (context) {
//           return const MessageScreen(message: 'page2');
//         },
//       },
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // ToastService.show('Welcome Back!');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HOME'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return DevPage(sl: sl);
//                   },
//                 ),
//               );
//             },
//             icon: const Icon(Icons.logo_dev),
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 GlobalVariables.navigatorState.currentState!
//                     .pushNamed('/message', arguments: 'Hello from global navigatorState');
//               },
//               child: const Text('page2 by global navigatorState'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed('/page2');
//               },
//               child: const Text('page2'),
//             ),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     ToastService.show('Welcome Back!');
//             //   },
//             //   child: const Text('Welcome Back'),
//             // ),
//             IconButton(
//               onPressed: () {
//                 final LocalNotificationHelper localNotificationHelper = sl<LocalNotificationHelper>();

//                 localNotificationHelper.showNotification(
//                   id: 0,
//                   title: 'Navigation Message',
//                   body: 'defaultImportanceChannel',
//                   payload: 'payload..',
//                   // notificationChannels: NotificationChannels.highImportanceChannel,
//                   notificationChannel: AppNotificationChannels.defaultImportanceChannel,
//                 );
//               },
//               icon: const Icon(Icons.notification_important_outlined),
//             ),

//             // default
//             IconButton(
//               onPressed: () {
//                 final LocalNotificationHelper localNotificationHelper = sl<LocalNotificationHelper>();

//                 localNotificationHelper.showNotification(
//                   id: 1,
//                   title: 'Tap This To Navigation Message Screen',
//                   body: 'highImportanceChannel',
//                   payload: 'payload..',
//                   notificationChannel: AppNotificationChannels.highImportanceChannel,
//                 );
//               },
//               icon: const Icon(Icons.notification_important),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MessageScreen extends StatelessWidget {
//   const MessageScreen({super.key, required this.message});

//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('MessageScreen'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Text(message),

//             //back btn using global navigatorState
//             ElevatedButton(
//               onPressed: () {
//                 GlobalVariables.navigatorState.currentState!.pop();
//               },
//               child: const Text('Back'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
