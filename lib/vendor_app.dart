import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';

import 'features/order/presentation/pages/vendor_order_purchase_page.dart';
import 'drawer.dart';
import 'features/auth/presentation/pages/no_permission_page.dart';
import 'features/product/presentation/pages/vendor_home_page.dart';
import 'features/auth/presentation/pages/vendor_login_page.dart';

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VTV Vendor',
      home: AppScaffold(),
    );
  }
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const VendorHomePage(),
    const VendorOrderPurchasePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _appTitle(int index) {
    switch (index) {
      case 0:
        return 'Vendor App';
      case 1:
        return '----';
      default:
        throw Exception('Invalid index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text(_appTitle(_selectedIndex)),
        // actions: const [
        //   // chat
        //   IconButton(
        //     icon: Icon(Icons.chat),
        //     onPressed: null,
        //   ),
        //   // notification
        //   IconButton(
        //     icon: Icon(Icons.notifications),
        //     onPressed: null, // TODO chat
        //   ),
        // ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  duration: const Duration(seconds: 3),
                ),
              );
          }
        },
        builder: (context, state) {
          // log('[AppScaffold] build with state: $state');
          if (state.status == AuthStatus.authenticated) {
            //# prevent user access to vendor app
            if (!state.auth!.userInfo.roles!.contains(Role.VENDOR)) {
              return NoAccessPermissionPage(refreshToken: state.auth!.refreshToken);
            } else {
              return _widgetOptions[_selectedIndex];
            }
          } else if (state.status == AuthStatus.unauthenticated) {
            return const VendorLoginPage(showTitle: false);
          }

          return const Center(
            child: Text(
              'Đang tải...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          );
        },
      ),
    );
  }
}
