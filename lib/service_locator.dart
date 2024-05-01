import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/features/shop/data/data_sources/shop_vendor_data_source.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/config.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';

import 'config/dio/auth_vendor_interceptor.dart';
import 'features/order/data/data_sources/order_vendor_data_source.dart';
import 'features/order/data/repository/order_vendor_repository_impl.dart';
import 'features/order/domain/repository/order_vendor_repository.dart';
import 'features/shop/data/repository/shop_vendor_repository_impl.dart';
import 'features/shop/domain/repository/shop_vendor_repository.dart';

// Service locator
GetIt sl = GetIt.instance;

Future<void> initializeLocator() async {
  //! External
  final connectivity = Connectivity();
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  final fMessaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final dio = Dio(dioOptions);
  dio.interceptors.addAll(
    [
      LogInterceptor(
        request: true,
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        error: false,
      ),
      AuthVendorInterceptor(),
      ErrorInterceptor(),
    ],
  );

  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<Dio>(dio);
  sl.registerSingleton<Connectivity>(connectivity);

  //! Core - Helpers - Managers
  sl.registerSingleton<SharedPreferencesHelper>(SharedPreferencesHelper(sharedPreferences));
  sl.registerSingleton<SecureStorageHelper>(SecureStorageHelper(secureStorage));

  sl.registerSingleton<LocalNotificationUtils>(LocalNotificationUtils(flutterLocalNotificationsPlugin));
  sl.registerSingleton<FirebaseCloudMessagingManager>(FirebaseCloudMessagingManager(fMessaging));

  //! Data source
  sl.registerSingleton<GuestDataSource>(GuestDataSourceImpl(sl()));
  sl.registerSingleton<AuthDataSource>(AuthDataSourceImpl(sl(), sl(), sl()));

  sl.registerSingleton<ShopVendorDataSource>(ShopVendorDataSourceImpl(sl()));
  sl.registerSingleton<OrderVendorDataSource>(OrderVendorDataSourceImpl(sl()));

  //! Repository
  sl.registerSingleton<GuestRepository>(GuestRepositoryImpl(sl()));
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));

  sl.registerSingleton<ShopVendorRepository>(ShopVendorRepositoryImpl(sl()));
  sl.registerSingleton<OrderVendorRepository>(OrderVendorRepositoryImpl(sl()));

  //! UseCase
  sl.registerLazySingleton<LoginWithUsernameAndPasswordUC>(() => LoginWithUsernameAndPasswordUC(sl()));
  sl.registerLazySingleton<LogoutUC>(() => LogoutUC(sl()));
  sl.registerLazySingleton<CheckTokenUC>(() => CheckTokenUC(sl()));

  //! Bloc
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl(), sl()));
}

// <https://pub.dev/packages/get_it>
