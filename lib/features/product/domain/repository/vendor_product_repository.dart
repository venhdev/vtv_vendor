import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/shop.dart';

import '../entities/add_product_resp.dart';
import '../entities/dto/add_update_product_param.dart';
import '../entities/category_with_nested_children_entity.dart';
import '../entities/dto/add_update_shop_category_request.dart';

abstract class VendorProductRepository {
//   POST
// /api/vendor/product/update/{productId}
  FRespData<ProductEntity> updateProduct(int productId, AddUpdateProductParam updateParam); // form-data

// POST
// /api/vendor/product/add
  FRespData<AddProductResp> addProduct(AddUpdateProductParam addParam); // form-data

// PATCH
// /api/vendor/product/update/{productId}/status/{status}
  FRespEither updateProductStatus(String productId, Status status);

// PATCH
// /api/vendor/product/restore/{productId}
  FRespEither restoreProduct(String productId);

// GET
// /api/vendor/product/page/status/{status}

  /// return list product (page) by status according to current logged vendor
  FRespData<ProductPageResp> getProductPageByStatus(int page, int size, Status status);

  //! category (custom)
  FRespData<List<CategoryWithNestedChildrenEntity>> getCategoryWithNestedChildren();

  //# category-shop-controller
  FRespData<List<ShopCategoryEntity>> getAllShopCategories();
  FRespData<ShopCategoryEntity> addProductsToCategoryShop(int categoryShopId, List<int> productIds);
  FRespData<ShopCategoryEntity> removeProductsFromCategoryShop(int categoryShopId, List<int> productIds);
  FRespData<ShopCategoryEntity> addShopCategory(AddUpdateShopCategoryRequest addParam);
  FRespData<ShopCategoryEntity> updateShopCategory(int categoryShopId, AddUpdateShopCategoryRequest updateParam);
  FRespEither deleteShopCategory(int categoryShopId);
}
