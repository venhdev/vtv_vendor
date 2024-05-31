import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/core/constants/global_variables.dart';
import 'package:vendor/features/notification/presentation/pages/vendor_notification_page.dart';
import 'package:vendor/features/wallet/presentation/pages/vendor_wallet_history_page.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';

import 'core/handler/vendor_handler.dart';
import 'features/auth/presentation/pages/no_permission_page.dart';
import 'features/auth/presentation/pages/vendor_login_page.dart';
import 'features/chat/presentation/pages/vendor_chat_room_page.dart';
import 'features/revenue/presentation/pages/revenue_page.dart';
import 'features/voucher/presentation/pages/add_update_voucher_page.dart';
import 'features/voucher/presentation/pages/vendor_voucher_manage_page.dart';
import 'service_locator.dart';
import 'vendor_drawer.dart';
import 'vendor_home_page.dart';

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<FirebaseCloudMessagingManager>().runWhenContainInitialMessage(
        (remoteMessage) {
          VendorHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
        },
      );
    });

    return MaterialApp(
      navigatorKey: GlobalVariables.navigatorState,
      debugShowCheckedModeBanner: false,
      title: 'VTV Vendor',
      home: const AppScaffold(),
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
  late List<Widget> _widgetOptions;

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
        return 'Ví tiền';
      case 2:
        return 'Voucher của shop';
      case 3:
        return 'Doanh thu';
      default:
        return 'Vendor App';
    }
  }

  List<Widget>? _actions(int index) {
    switch (index) {
      case 0:
        return [
          //# notification
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const VendorNotificationPage();
                  },
                ),
              );
            },
          ),

          //# chat
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const VendorChatRoomPage();
                  },
                ),
              );
            },
          ),
        ];
      case 2:
        return [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              _onItemTapped(0);
            },
          ),
        ];
      default:
        return null;
    }
  }

  Widget? _floatingActionButton(int index) {
    switch (index) {
      case 2:
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const AddUpdateVoucherPage();
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      VendorHomePage(onItemTapped: _onItemTapped),
      const VendorWalletHistoryPage(),
      const VendorVoucherManagePage(),
      const RevenuePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: VendorDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text(_appTitle(_selectedIndex)),
        actions: _actions(_selectedIndex),
      ),
      floatingActionButton: _floatingActionButton(_selectedIndex),
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
