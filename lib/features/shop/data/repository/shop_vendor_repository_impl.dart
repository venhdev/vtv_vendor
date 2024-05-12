import 'package:vendor/features/shop/data/data_sources/vendor_shop_data_source.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../../domain/repository/shop_vendor_repository.dart';

class ShopVendorRepositoryImpl implements ShopVendorRepository {
  final VendorShopDataSource _shopDataSource;

  ShopVendorRepositoryImpl(this._shopDataSource);

  @override
  FRespData<ShopEntity> getShopProfile() async {
    return handleDataResponseFromDataSource(dataCallback: () => _shopDataSource.getShopProfile());
  }
}
