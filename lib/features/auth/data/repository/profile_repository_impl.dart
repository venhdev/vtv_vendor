import 'package:vendor/features/auth/data/data_sources/profile_data_source.dart';
import 'package:vendor/features/auth/domain/entities/vendor_register_param.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../../domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _shopDataSource;

  ProfileRepositoryImpl(this._shopDataSource);

  @override
  FRespData<ShopEntity> getShopProfile() async {
    return handleDataResponseFromDataSource(dataCallback: () => _shopDataSource.getShopProfile());
  }

  @override
  FRespData<ShopEntity> registerVendor(VendorRegisterParam param) async {
    return handleDataResponseFromDataSource(dataCallback: () => _shopDataSource.registerVendor(param));
  }

  @override
  FRespData<ShopEntity> updateProfile(VendorRegisterParam param) {
    return handleDataResponseFromDataSource(dataCallback: () => _shopDataSource.updateProfile(param));
  }
}
