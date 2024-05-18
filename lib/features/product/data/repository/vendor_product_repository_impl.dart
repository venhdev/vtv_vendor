import 'package:dartz/dartz.dart';
import 'package:vendor/features/product/domain/entities/category_with_nested_children_entity.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/home.dart';

import '../../domain/entities/add_product_resp.dart';
import '../../domain/entities/dto/add_update_product_param.dart';
import '../../domain/repository/vendor_product_repository.dart';
import '../data_sources/vendor_product_data_source.dart';

class VendorProductRepositoryImpl implements VendorProductRepository {
  VendorProductRepositoryImpl(this._dataSource, this._guestDataSource);
  final VendorProductDataSource _dataSource;
  final GuestDataSource _guestDataSource;

  @override
  FRespData<AddProductResp> addProduct(AddUpdateProductParam addParam) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.addProduct(addParam));
  }

  @override
  FRespData<List<CategoryWithNestedChildrenEntity>> getCategoryWithNestedChildren() async {
    Future<List<CategoryWithNestedChildrenEntity>> getNestedChildrenOfCategory(int categoryId) async {
      List<CategoryWithNestedChildrenEntity> rs = [];

      final children = await _guestDataSource.getAllCategoryByParent(categoryId);

      // get list of children categories (when children is empty, it means it's a leaf node)
      await Future.wait(children.data!.map((parent) async {
        final children = await _guestDataSource.getAllCategoryByParent(parent.categoryId);

        if (children.data!.isEmpty) {
          return rs.add(
            CategoryWithNestedChildrenEntity(
              parent: parent,
              children: [],
            ),
          );
        } else {
          return rs.add(
            CategoryWithNestedChildrenEntity(
              parent: parent,
              children: await getNestedChildrenOfCategory(categoryId),
            ),
          );
        }
      }));

      return rs;
    }

    try {
      final List<CategoryWithNestedChildrenEntity> result = [];
      // get list of parent categories
      final parentCategories = await _guestDataSource.getAllParentCategory();

      // get list of children categories (when children is empty, it means it's a leaf node)
      await Future.wait(parentCategories.data!.map((parent) async {
        final children = await _guestDataSource.getAllCategoryByParent(parent.categoryId);

        if (children.data!.isEmpty) {
          return result.add(
            CategoryWithNestedChildrenEntity(
              parent: parent,
              children: [],
            ),
          );
        } else {
          // for each children, get list of nested children
          List<CategoryWithNestedChildrenEntity> childrenList = [];

          await Future.wait(children.data!.map((child) async {
            childrenList.add(
              CategoryWithNestedChildrenEntity(
                parent: child,
                children: await getNestedChildrenOfCategory(child.categoryId),
              ),
            );
          }));

          result.add(
            CategoryWithNestedChildrenEntity(
              parent: parent,
              children: childrenList,
            ),
          );
        }
      }));

      return Right(SuccessResponse(
        code: 200,
        status: 'success',
        message: 'Get category with nested children successfully',
        data: result,
      ));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespData<ProductPageResp> getProductByStatus(int page, int size, Status status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getProductByStatus(page, size, status));
  }

  @override
  FRespEither restoreProduct(String productId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.restoreProduct(productId));
  }

  @override
  FRespEither updateProductStatus(String productId, Status status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.updateProductStatus(productId, status));
  }

  @override
  FRespData<ProductEntity> updateProduct(int productId, AddUpdateProductParam updateParam) async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.updateProduct(productId, updateParam));
  }
}
