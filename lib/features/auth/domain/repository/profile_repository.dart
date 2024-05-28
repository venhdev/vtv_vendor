import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../entities/request/vendor_register_update_request.dart';

abstract class ProfileRepository {
  //# shop-controller
// PUT
// /api/vendor/shop/update
// const String kAPIVendorShopUpdateURL = '/vendor/shop/update';
  FRespData<ShopEntity> updateProfile(ShopRegisterUpdateRequest param);

// POST
// /api/vendor/register
// const String kAPIVendorRegisterURL = '/vendor/register';
  FRespData<ShopEntity> registerVendor(ShopRegisterUpdateRequest param);

// PATCH
// /api/vendor/shop/update/status/{status}
// const String kAPIVendorShopUpdateStatusURL = '/vendor/shop/update/status/:status'; // {status}

// GET
// /api/vendor/shop/profile
// const String kAPIVendorShopProfileURL = '/vendor/shop/profile';
  FRespData<ShopEntity> getShopProfile();
}
