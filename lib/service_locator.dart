import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/features/auth/data/data_sources/profile_data_source.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/config.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';

import 'config/dio/vendor_auth_interceptor.dart';
import 'features/notification/data/data_sources/vendor_notification_data_source.dart';
import 'features/notification/data/repository/vendor_notification_repository_impl.dart';
import 'features/notification/domain/repository/vendor_notification_repository.dart';
import 'features/order/data/data_sources/vendor_order_data_source.dart';
import 'features/order/data/repository/vendor_order_repository_impl.dart';
import 'features/order/domain/repository/vendor_order_repository.dart';
import 'features/auth/data/repository/profile_repository_impl.dart';
import 'features/auth/domain/repository/profile_repository.dart';
import 'features/product/data/data_sources/vendor_product_data_source.dart';
import 'features/product/data/data_sources/shop_category_data_source.dart';
import 'features/product/data/repository/vendor_product_repository_impl.dart';
import 'features/product/domain/repository/vendor_product_repository.dart';
import 'features/wallet/data/data_sources/wallet_data_source.dart';
import 'features/wallet/data/repository/wallet_repository_impl.dart';
import 'features/wallet/domain/repository/wallet_repository.dart';
import 'features/voucher/data/data_sources/voucher_data_source.dart';
import 'features/voucher/domain/repository/voucher_repository.dart';

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
        requestHeader: true,
        responseHeader: false,
        error: false,
      ),
      VendorAuthInterceptor(),
      ErrorInterceptor(),
    ],
  );

  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<Dio>(dio);
  sl.registerSingleton<Connectivity>(connectivity);

  //! Core - Helpers - Managers
  sl.registerSingleton<SharedPreferencesHelper>(SharedPreferencesHelper(sharedPreferences));
  sl.registerSingleton<SecureStorageHelper>(SecureStorageHelper(secureStorage));

  sl.registerSingleton<LocalNotificationHelper>(LocalNotificationHelper(flutterLocalNotificationsPlugin));
  sl.registerSingleton<FirebaseCloudMessagingManager>(FirebaseCloudMessagingManager(fMessaging));

  //! Data source
  sl.registerSingleton<GuestDataSource>(GuestDataSourceImpl(sl()));
  sl.registerSingleton<ChatDataSource>(ChatDataSourceImpl(sl()));
  sl.registerSingleton<ProfileDataSource>(ProfileDataSourceImpl(sl()));
  sl.registerSingleton<WalletDataSource>(WalletDataSourceImpl(sl()));
  sl.registerSingleton<VendorOrderDataSource>(OrderVendorDataSourceImpl(sl()));

  sl.registerSingleton<VendorShopCategoryDataSource>(VendorShopCategoryDataSourceImpl(sl()));
  sl.registerSingleton<VendorNotificationDataSource>(VendorNotificationDataSourceImpl(sl()));
  sl.registerSingleton<VendorProductDataSource>(VendorProductDataSourceImpl(sl()));
  sl.registerSingleton<AuthDataSource>(AuthDataSourceImpl(sl(), sl(), sl(), sl()));
  sl.registerSingleton<VoucherDataSource>(VoucherDataSourceImpl(sl()));

  //! Repository
  sl.registerSingleton<GuestRepository>(GuestRepositoryImpl(sl()));
  sl.registerSingleton<ChatRepository>(ChatRepositoryImpl(sl()));
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));
  sl.registerSingleton<VendorRepository>(VendorRepositoryImpl(sl()));
  sl.registerSingleton<VendorProductRepository>(VendorProductRepositoryImpl(sl(), sl(), sl()));
  sl.registerSingleton<VoucherRepository>(VoucherRepositoryImpl(sl()));
  sl.registerSingleton<VendorNotificationRepository>(VendorNotificationRepositoryImpl(sl()));

  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(sl()));
  sl.registerSingleton<VendorOrderRepository>(VendorOrderRepositoryImpl(sl()));

  //! UseCase
  sl.registerLazySingleton<LoginWithUsernameAndPasswordUC>(() => LoginWithUsernameAndPasswordUC(sl()));
  sl.registerLazySingleton<LogoutUC>(() => LogoutUC(sl()));
  sl.registerLazySingleton<CheckTokenUC>(() => CheckTokenUC(sl()));

  //! Bloc
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl(), sl()));
}

// <https://pub.dev/packages/get_it>
