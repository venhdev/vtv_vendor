import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vendor/config/firebase_options.dart';
import 'package:vendor/service_locator.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/dev.dart';

import 'vendor_app.dart';

void main() async {
  // WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeLocator();
  sl<LocalNotificationUtils>().init();
  sl<FirebaseCloudMessagingManager>().init();

  final authCubit = sl<AuthCubit>()..onStarted();

  // NOTE: dev
  final savedHost = sl<SharedPreferencesHelper>().I.getString('host');
  if (savedHost != null) {
    host = savedHost;
  } else {
    final curHost = await DevUtils.initHostWithCurrentIPv4();
    if (curHost != null) {
      host = curHost;
      sl<SharedPreferencesHelper>().I.setString('host', curHost);
    }
  }

  runApp(MultiProvider(
    providers: [
      BlocProvider(create: (context) => authCubit),
    ],
    child: const VendorApp(),
  ));
}
