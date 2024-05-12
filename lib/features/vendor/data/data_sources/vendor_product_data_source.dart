import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';

import '../../../../core/constants/vendor_api.dart';
import '../../domain/entities/add_product_resp.dart';
import '../../domain/entities/dto/add_and_update_product_param.dart';

abstract class VendorProductDataSource {
//   POST
// /api/vendor/product/update/{productId}

// POST
// /api/vendor/product/add
  Future<SuccessResponse<AddProductResp>> addProduct(AddUpdateProductParam addParam); // form-data

// PATCH
// /api/vendor/product/update/{productId}/status/{status}

// PATCH
// /api/vendor/product/restore/{productId}

// GET
// /api/vendor/product/page/status/{status}
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
      if (addParam.image != null) 'image': await FileUtils.getMultiPartFileViaPath(addParam.image!),
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

    log('mapData: $mapData');
    FormData formData = FormData.fromMap(mapData, ListFormat.multiCompatible);
    log('=========fields: ${formData.fields}');
    log('=========files: ${formData.files}');

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
}
