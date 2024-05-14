import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../entities/vendor_register_param.dart';

abstract class ProfileRepository {
  //# shop-controller
// PUT
// /api/vendor/shop/update
// const String kAPIVendorShopUpdateURL = '/vendor/shop/update';
  FRespData<ShopEntity> updateProfile(VendorRegisterParam param);

// POST
// /api/vendor/register
// const String kAPIVendorRegisterURL = '/vendor/register';
  FRespData<ShopEntity> registerVendor(VendorRegisterParam param);

// PATCH
// /api/vendor/shop/update/status/{status}
// const String kAPIVendorShopUpdateStatusURL = '/vendor/shop/update/status/:status'; // {status}

// GET
// /api/vendor/shop/profile
// const String kAPIVendorShopProfileURL = '/vendor/shop/profile';
  FRespData<ShopEntity> getShopProfile();
}
