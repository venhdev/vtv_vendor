import 'package:vendor/features/auth/data/datasources/profile_data_source.dart';
import 'package:vendor/features/auth/domain/entities/request/vendor_register_update_request.dart';
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
  FRespData<ShopEntity> registerVendor(ShopRegisterUpdateRequest param) async {
    return handleDataResponseFromDataSource(dataCallback: () => _shopDataSource.registerVendor(param));
  }

  @override
  FRespData<ShopEntity> updateProfile(ShopRegisterUpdateRequest param) {
    return handleDataResponseFromDataSource(dataCallback: () => _shopDataSource.updateProfile(param));
  }
}
