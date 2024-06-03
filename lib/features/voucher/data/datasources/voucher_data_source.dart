import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/constants/vendor_api.dart';

abstract class VoucherDataSource {
  //# voucher-shop-controller
  // const String kAPIVoucherUpdateURL = '/vendor/shop/voucher/update';
  Future<SuccessResponse<VoucherEntity>> updateVoucher(VoucherEntity voucher);
  // const String kAPIVoucherAddURL = '/vendor/shop/voucher/add';
  Future<SuccessResponse<VoucherEntity>> addVoucher(VoucherEntity voucher);
  // const String kAPIVoucherUpdateStatusURL = '/vendor/shop/voucher/update-status/:voucherId'; // {voucherId}
  Future<SuccessResponse<VoucherEntity>> updateVoucherStatus(String voucherId, Status status);
  // const String kAPIVoucherGetAllURL = '/vendor/shop/voucher/get-all-shop';
  Future<SuccessResponse<List<VoucherEntity>>> getAllVoucher();
  // const String kAPIVoucherGetAllByTypeURL = '/vendor/shop/voucher/get-all-shop-type';
  Future<SuccessResponse<List<VoucherEntity>>> getAllVoucherByType(VoucherType type);
  // const String kAPIVoucherGetAllByStatusURL = '/vendor/shop/voucher/get-all-shop-status';
  Future<SuccessResponse<List<VoucherEntity>>> getAllVoucherByStatus(Status status);
  // const String kAPIVoucherDetailURL = '/vendor/shop/voucher/detail/:voucherId'; // {voucherId}
  Future<SuccessResponse<VoucherEntity>> getVoucherDetail(int voucherId);
}

class VoucherDataSourceImpl implements VoucherDataSource {
  final Dio _dio;

  VoucherDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<VoucherEntity>> addVoucher(VoucherEntity voucher) async {
    assert(voucher.status == Status.ACTIVE || voucher.status == Status.DELETED);

    final url = uriBuilder(path: kAPIVoucherAddURL);
    final response = await _dio.postUri(url, data: voucher.toMap());

    return handleDioResponse<VoucherEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => VoucherEntity.fromMap(jsonMap['voucherDTO']),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> getAllVoucher() async {
    final url = uriBuilder(path: kAPIVoucherGetAllURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<List<VoucherEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['voucherDTOs'] as List).map((e) => VoucherEntity.fromMap(e)).toList(),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> getAllVoucherByStatus(Status status) async {
    assert(status == Status.ACTIVE || status == Status.DELETED);

    final url = uriBuilder(
      path: kAPIVoucherGetAllByStatusURL,
      queryParameters: {'status': status.name},
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<List<VoucherEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['voucherDTOs'] as List).map((e) => VoucherEntity.fromMap(e)).toList(),
    );
  }

  @override
  Future<SuccessResponse<List<VoucherEntity>>> getAllVoucherByType(VoucherType type) async {
    final url = uriBuilder(
      path: kAPIVoucherGetAllByTypeURL,
      queryParameters: {'type': type.name},
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<List<VoucherEntity>, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => (jsonMap['voucherDTOs'] as List).map((e) => VoucherEntity.fromMap(e)).toList(),
    );
  }

  @override
  Future<SuccessResponse<VoucherEntity>> getVoucherDetail(int voucherId) async {
    final url = uriBuilder(
      path: kAPIVoucherDetailURL,
      pathVariables: {'voucherId': voucherId.toString()},
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<VoucherEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => VoucherEntity.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<VoucherEntity>> updateVoucher(VoucherEntity voucher) async {
    assert(voucher.status == Status.ACTIVE || voucher.status == Status.DELETED);

    final url = uriBuilder(path: '$kAPIVoucherUpdateURL/${voucher.voucherId}');

    final response = await _dio.putUri(url, data: voucher.toMap());

    return handleDioResponse<VoucherEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => VoucherEntity.fromMap(jsonMap['voucherDTO']),
    );
  }

  @override
  Future<SuccessResponse<VoucherEntity>> updateVoucherStatus(String voucherId, Status status) async {
    final url = uriBuilder(
      path: kAPIVoucherUpdateStatusURL,
      pathVariables: {'voucherId': voucherId},
      queryParameters: {'status': status.name},
    );

    final response = await _dio.patchUri(url);

    return handleDioResponse<VoucherEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => VoucherEntity.fromMap(jsonMap['voucherDTO']),
    );
  }
}
