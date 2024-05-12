import 'package:dartz/dartz.dart';
import 'package:vendor/features/vendor/domain/entities/category_with_nested_children_entity.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';

import '../../domain/entities/add_product_resp.dart';
import '../../domain/entities/dto/add_and_update_product_param.dart';
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
    try {
      final List<CategoryWithNestedChildrenEntity> result = [];
      // get list of parent categories
      final parentCategories = await _guestDataSource.getAllParentCategory();

      // get list of children categories (when children is empty, it means it's a leaf node)
      await Future.wait(parentCategories.data!.map((parent) async {
        final children = await _guestDataSource.getAllCategoryByParent(parent.categoryId);
        result.add(
          CategoryWithNestedChildrenEntity(
            parent: parent,
            children: children.data!,
          ),
        );
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
}
