import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/dev.dart';

import '../../../../service_locator.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  final int selectedIndex;
  final void Function(int index) onItemTapped;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader(),
          ListTile(
            title: const Text('Tổng quan cửa hàng'),
            selected: widget.selectedIndex == 0,
            onTap: () {
              widget.onItemTapped(0);
              Navigator.pop(context);
            },
          ),

          // NOTE dev
          const Divider(),
          ListTile(
            title: const Text('Dev Page'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DevPage(sl: sl);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  BlocBuilder<AuthCubit, AuthState> drawerHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final auth = state.auth!;
          return UserAccountsDrawerHeader(
            accountName: Text(
              auth.userInfo.fullName ?? auth.userInfo.username ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              auth.userInfo.email ?? 'Email',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: const FlutterLogo(),
            otherAccountsPictures: [
              // logout icon
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () async {
                  // show dialog to confirm logout
                  final isConfirm = await showDialogToConfirm(
                    context: context,
                    title: 'Đăng xuất',
                    content: 'Bạn có chắc chắn muốn đăng xuất?',
                  );
                  if (isConfirm) {
                    if (context.mounted) {
                      await context
                          .read<AuthCubit>()
                          .logout(state.auth!.refreshToken)
                          .then((value) => Navigator.pop(context));
                    }
                  }
                },
              ),
            ],
          );
        } else if (state.status == AuthStatus.unauthenticated) {
          return _authenticatedDrawerHeader(context);
        }
        return DrawerHeader(
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Đang tải...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                ElevatedButton(
                  onPressed: () {
                    log(state.toString());
                  },
                  child: const Text('Button'),
                ),
                ElevatedButton(
                  onPressed: () {
                    log('current domain: $host');
                  },
                  child: const Text('current domain'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DrawerHeader _authenticatedDrawerHeader(BuildContext context) {
    return DrawerHeader(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Đăng nhập'),
        ),
      ),
    );
  }
}
