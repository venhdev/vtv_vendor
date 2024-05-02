import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';

import 'features/order/presentation/pages/vendor_order_purchase_page.dart';
import 'features/vendor/presentation/components/app_drawer.dart';
import 'features/vendor/presentation/pages/vendor_home_page.dart';

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
        return 'Shop của bạn';
      case 1:
        return '----';
      default:
        throw Exception('Invalid index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          if (!state.auth!.userInfo.roles!.contains(Role.VENDOR)) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ứng dụng chỉ dành cho người bán hàng',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),

                    //btn logout
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout(state.auth!.refreshToken);
                      },
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Scaffold(
          drawer: AppDrawer(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
          appBar: AppBar(
            title: Text(_appTitle(_selectedIndex)),
            actions: const [
              // chat
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: null,
              ),
              // notification
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: null, // TODO chat
              ),
            ],
          ),
          body: _widgetOptions[_selectedIndex],
        );
      },
    );
  }
}
