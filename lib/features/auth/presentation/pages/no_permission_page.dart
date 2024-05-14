import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';

class NoAccessPermissionPage extends StatelessWidget {
  const NoAccessPermissionPage({
    super.key,
    required this.refreshToken,
  });

  final String refreshToken;

  @override
  Widget build(BuildContext context) {
    return Center(
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
              context.read<AuthCubit>().logout(refreshToken);
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
