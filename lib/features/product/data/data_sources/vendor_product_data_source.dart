import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../core/constants/vendor_api.dart';
import '../../domain/entities/add_product_resp.dart';
import '../../domain/entities/dto/add_update_product_param.dart';

abstract class VendorProductDataSource {
//   POST
// /api/vendor/product/update/{productId}
  Future<SuccessResponse<ProductEntity>> updateProduct(int productId, AddUpdateProductParam updateParam); // form-data

// POST
// /api/vendor/product/add
  Future<SuccessResponse<AddProductResp>> addProduct(AddUpdateProductParam addParam); // form-data

// PATCH
// /api/vendor/product/update/{productId}/status/{status}
  Future<SuccessResponse> updateProductStatus(String productId, Status status);

// PATCH
// /api/vendor/product/restore/{productId}
  Future<SuccessResponse> restoreProduct(String productId);

// GET
// /api/vendor/product/page/status/{status}
  Future<SuccessResponse<ProductPageResp>> getProductByStatus(int page, int size, Status status);
}

class VendorProductDataSourceImpl implements VendorProductDataSource {
  final Dio _dio;

  VendorProductDataSourceImpl(this._dio);

  @override
  Future<SuccessResponse<AddProductResp>> addProduct(AddUpdateProductParam addParam) async {
    List<Iterable<MapEntry<String, Object?>>> variantEntries = [];

    for (int i = 0; i < addParam.productVariantRequests.length; i++) {
      final variant = addParam.productVariantRequests[i];
      final entries = ConversionUtils.flattenObjectWithPrefixIndex(
        await variant.toMap(),
        index: i,
        prefix: 'productVariantRequests',
      );
      variantEntries.add(entries);
    }

    final mapData = {
      'productId': addParam.productId,
      'name': addParam.name,
      if (addParam.image != null && addParam.changeImage)
        'image': await FileUtils.getMultiPartFileViaPath(addParam.image!),
      'changeImage': addParam.changeImage,
      'description': addParam.description,
      'information': addParam.information,
      'categoryId': addParam.categoryId,
      'brandId': addParam.brandId,
    };

    // for (var variantEntry in variantEntries) {
    //   mapData.addEntries(variantEntry);
    // }
    mapData.addEntries(
      variantEntries.expand<MapEntry<String, Object?>>((element) => element),
    );

    FormData formData = FormData.fromMap(mapData);

    final url = baseUri(path: kAPIVendorProductAddURL);

    final response = await _dio.postUri(
      url,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return handleDioResponse<AddProductResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => AddProductResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<ProductPageResp>> getProductByStatus(int page, int size, Status status) async {
    final url = baseUri(
      path: kAPIVendorProductPageStatusURL,
      queryParameters: {
        'page': page,
        'size': size,
      }.map((key, value) => MapEntry(key, value.toString())),
      pathVariables: {
        'status': status.name,
      },
    );

    final response = await _dio.getUri(url);

    return handleDioResponse<ProductPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductPageResp.fromMap(jsonMap),
    );
  }

  @override
  Future<SuccessResponse<Object?>> restoreProduct(String productId) async {
    final url = baseUri(
      path: kAPIVendorProductRestoreURL,
      pathVariables: {
        'productId': productId,
      },
    );

    final response = await _dio.patchUri(url);

    return handleDioResponse(response, url, hasData: false);
  }

  @override
  Future<SuccessResponse<Object?>> updateProductStatus(String productId, Status status) async {
    final url = baseUri(
      path: kAPIVendorProductUpdateStatusURL,
      pathVariables: {
        'productId': productId,
        'status': status.name,
      },
    );

    final response = await _dio.patchUri(url);

    return handleDioResponse(response, url, hasData: false);
  }

  @override
  Future<SuccessResponse<ProductEntity>> updateProduct(int productId, AddUpdateProductParam updateParam) async {
    List<Iterable<MapEntry<String, Object?>>> variantEntries = [];

    for (int i = 0; i < updateParam.productVariantRequests.length; i++) {
      var variant = updateParam.productVariantRequests[i];

      final entries = ConversionUtils.flattenObjectWithPrefixIndex(
        await variant.toMap(),
        index: i,
        prefix: 'productVariantRequests',
      );
      variantEntries.add(entries);
    }

    final mapData = {
      'productId': updateParam.productId,
      'name': updateParam.name,
      if (updateParam.image != null && updateParam.changeImage)
        'image': await FileUtils.getMultiPartFileViaPath(updateParam.image!),
      'changeImage': updateParam.changeImage,
      'description': updateParam.description,
      'information': updateParam.information,
      'categoryId': updateParam.categoryId,
      'brandId': updateParam.brandId,
    };

    // for (var variantEntry in variantEntries) {
    //   mapData.addEntries(variantEntry);
    // }
    mapData.addEntries(
      variantEntries.expand<MapEntry<String, Object?>>((element) => element),
    );

    FormData formData = FormData.fromMap(mapData);

    final url = baseUri(
      path: kAPIVendorProductUpdateURL,
      pathVariables: {
        'productId': productId.toString(),
      },
    );

    final response = await _dio.postUri(
      url,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return handleDioResponse<ProductEntity, Map<String, dynamic>>(
      response,
      url,
      parse: (jsonMap) => ProductEntity.fromMap(jsonMap['productDTO']),
    );
  }
}
