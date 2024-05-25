import 'package:dio/dio.dart';
import 'package:vendor/core/constants/vendor_api.dart';
import 'package:vendor/features/auth/domain/entities/vendor_register_param.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

abstract class ProfileDataSource {
  //# shop-controller
// PUT
// /api/vendor/shop/update
// const String kAPIVendorShopUpdateURL = '/vendor/shop/update';
  Future<SuccessResponse<ShopEntity>> updateProfile(VendorRegisterParam param);

// POST
// /api/vendor/register
// const String kAPIVendorRegisterURL = '/vendor/register';
  Future<SuccessResponse<ShopEntity>> registerVendor(VendorRegisterParam param);

// PATCH
// /api/vendor/shop/update/status/{status}
// const String kAPIVendorShopUpdateStatusURL = '/vendor/shop/update/status/:status'; // {status}

// GET
// /api/vendor/shop/profile
// const String kAPIVendorShopProfileURL = '/vendor/shop/profile';
  Future<SuccessResponse<ShopEntity>> getShopProfile();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final Dio _dio;

  ProfileDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<ShopEntity>> getShopProfile() async {
    final url = uriBuilder(path: kAPIVendorShopProfileURL);

    final response = await _dio.getUri(url);

    return handleDioResponse<ShopEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopEntity.fromMap(jsonMap['shopDTO']),
    );
  }

  @override
  Future<SuccessResponse<ShopEntity>> registerVendor(VendorRegisterParam param) async {
    final url = uriBuilder(path: kAPIVendorRegisterURL);

    final formData = FormData.fromMap(await param.toMap());

    final response = await _dio.postUri(
      url,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    return handleDioResponse<ShopEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopEntity.fromMap(jsonMap['shopDTO']),
    );
  }

  @override
  Future<SuccessResponse<ShopEntity>> updateProfile(VendorRegisterParam param) async {
    final url = uriBuilder(path: kAPIVendorShopUpdateURL);

    final formData = FormData.fromMap(await param.toMap());

    final response = await _dio.putUri(
      url,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    return handleDioResponse<ShopEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ShopEntity.fromMap(jsonMap['shopDTO']),
    );
  }
}
