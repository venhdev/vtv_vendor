import 'package:vtv_common/core.dart';

import '../../domain/entities/add_product_resp.dart';
import '../../domain/entities/dto/add_and_update_product_param.dart';
import '../entities/category_with_nested_children_entity.dart';

abstract class VendorProductRepository {
//   POST
// /api/vendor/product/update/{productId}

// POST
// /api/vendor/product/add
  FRespData<AddProductResp> addProduct(AddUpdateProductParam addParam); // form-data

// PATCH
// /api/vendor/product/update/{productId}/status/{status}

// PATCH
// /api/vendor/product/restore/{productId}

// GET
// /api/vendor/product/page/status/{status}

  //! category (custom)
  FRespData<List<CategoryWithNestedChildrenEntity>> getCategoryWithNestedChildren();
}
