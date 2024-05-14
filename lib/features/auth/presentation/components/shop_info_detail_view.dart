import 'package:flutter/material.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/shop.dart';

import '../../../../service_locator.dart';

class ShopInfoDetailView extends StatelessWidget {
  const ShopInfoDetailView({
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
                        return ShopInfoDetailPage(
                          shopDetail: ok.data!,
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
    // return FutureBuilder(
    //   future: sl<ShopVendorRepository>().getShopProfile(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       final resultEither = snapshot.data!;

    //       return resultEither.fold(
    //         (error) => const SizedBox.shrink(),
    //         (ok) {
    //           return FutureBuilder(
    //             future: sl<GuestRepository>().getShopDetailById(ok.data!.shopId),
    //             builder: (context, snapshot) {
    //               if (snapshot.hasData) {
    //                 return snapshot.data!.fold(
    //                   (error) => const SizedBox.shrink(),
    //                   (ok) {
    //                     return ShopInfo(
    //                       shopId: ok.data!.shop.shopId,
    //                       shopDetail: ok.data!,
    //                       shopName: ok.data!.shop.name,
    //                       shopAvatar: ok.data!.shop.avatar,
    //                       showFollowedCount: true,
    //                       showShopDetail: true,
    //                       decoration: BoxDecoration(
    //                         color: Theme.of(context).colorScheme.surface,
    //                         borderRadius: BorderRadius.circular(8),
    //                         boxShadow: const [
    //                           BoxShadow(
    //                             color: Colors.black12,
    //                             blurRadius: 4,
    //                             offset: Offset(0, 2),
    //                           ),
    //                         ],
    //                       ),
    //                       onPressed: () {
    //                         Navigator.of(context).push(
    //                           MaterialPageRoute(
    //                             builder: (context) {
    //                               return ShopInfoDetailPage(
    //                                 shopDetail: ok.data!,
    //                               );
    //                             },
    //                           ),
    //                         );
    //                       },
    //                     );
    //                   },
    //                 );
    //               }
    //               return const SizedBox.shrink();
    //             },
    //           );
    //         },
    //       );
    //     }
    //     return const SizedBox.shrink();
    //   },
    // );
  }
}
