import 'package:flutter/material.dart';
import 'package:vendor/features/auth/domain/entities/request/vendor_register_update_request.dart';
import 'package:vendor/features/auth/presentation/pages/vendor_register_update_page.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/shop.dart';

import '../../../../service_locator.dart';

class VendorShopInfoView extends StatelessWidget {
  const VendorShopInfoView({
    super.key,
    required this.shopId,
  });

  final int shopId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<GuestRepository>().getShopDetailById(shopId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (error) => const SizedBox.shrink(),
            (ok) {
              return ShopInfo(
                shopId: ok.data!.shop.shopId,
                shopDetail: ok.data!,
                shopName: ok.data!.shop.name,
                shopAvatar: ok.data!.shop.avatar,
                showFollowedCount: true,
                showShopDetail: true,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ShopDetailPage(
                          shopDetail: ok.data!,
                          bottomActionBuilder: ElevatedButton(
                            onPressed: () {
                              final ShopRegisterUpdateRequest updateParam = ShopRegisterUpdateRequest(
                                changeAvatar: false,
                                name: ok.data!.shop.name,
                                address: ok.data!.shop.address,
                                provinceName: ok.data!.shop.provinceName,
                                districtName: ok.data!.shop.districtName,
                                wardName: ok.data!.shop.wardName,
                                phone: ok.data!.shop.phone,
                                email: ok.data!.shop.email,
                                avatar: ok.data!.shop.avatar,
                                description: ok.data!.shop.description,
                                openTime: ok.data!.shop.openTime,
                                closeTime: ok.data!.shop.closeTime,
                                wardCode: ok.data!.shop.wardCode,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return VendorRegisterUpdatePage(
                                      isUpdate: true,
                                      initParam: updateParam,
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text('Chỉnh sửa thông tin cửa hàng'),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
