import 'package:flutter/material.dart';
import 'package:vendor/features/auth/presentation/pages/vendor_register_update_page.dart';
import 'package:vtv_common/core.dart';

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
            'Hiện tại bạn chưa có quyền truy cập vào ứng dụng. Vui lòng đăng ký để sử dụng dịch vụ.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),

          // register vendor
          ElevatedButton(
            onPressed: () async {
              final isRegistered = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) {
                    return const VendorRegisterUpdatePage();
                  },
                ),
              );

              if (isRegistered ?? false) {
                if (!context.mounted) return;
                showDialogToAlert(
                  context,
                  title: const Text('Đăng ký thành công'),
                  children: [const Text('Vui lòng đăng nhập lại để tiếp tục')],
                );
              }
            },
            child: const Text('Đăng ký bán hàng'),
          ),
        ],
      ),
    );
  }
}
