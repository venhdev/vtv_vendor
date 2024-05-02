import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';

import '../../../shop/presentation/components/shop_info_detail_view.dart';
import '../components/order_purchase_tracking.dart';
import 'vendor_login_page.dart';

class VendorHomePage extends StatelessWidget {
  const VendorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message!),
                duration: const Duration(seconds: 2),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const VendorLoginPage(showTitle: false);
        } else if (state.status == AuthStatus.authenticated) {
          return _buildBody(context);
        }
        return const Scaffold(
          body: Center(
            child: Text(
              'Đang tải...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return const Column(
      children: [
        ShopInfoDetailView(),
        OrderPurchaseTracking(),
      ],
    );
  }
}
