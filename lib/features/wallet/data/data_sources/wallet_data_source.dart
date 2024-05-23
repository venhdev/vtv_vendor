import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/wallet.dart';

import '../../../../core/constants/vendor_api.dart';

abstract class WalletDataSource {
  //#wallet-controller
  // GET
  // /api/customer/wallet/get
  Future<SuccessResponse<WalletEntity>> getWallet();
}

class WalletDataSourceImpl implements WalletDataSource {
  final Dio _dio;

  WalletDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<WalletEntity>> getWallet() async {
    final url = uriBuilder(path: kAPIWalletGetURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<WalletEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => WalletEntity.fromMap(jsonMap['walletDTO']),
    );
  }
}
