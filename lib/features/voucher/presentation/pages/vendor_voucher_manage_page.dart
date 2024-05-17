import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/voucher_repository.dart';
import '../components/vendor_voucher_item.dart';

class VendorVoucherManagePage extends StatefulWidget {
  const VendorVoucherManagePage({super.key});

  @override
  State<VendorVoucherManagePage> createState() => _VendorVoucherManagePageState();
}

class _VendorVoucherManagePageState extends State<VendorVoucherManagePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<VoucherRepository>().getAllVoucher(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final respEither = snapshot.data!;

          return respEither.fold(
            (error) => MessageScreen.error(error.message),
            (ok) {
              if (ok.data!.isEmpty) {
                return const MessageScreen(message: 'Không tìm thấy voucher nào của shop!');
              }

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 72, top: 4, left: 4, right: 4),
                  itemCount: ok.data!.length,
                  itemBuilder: (context, index) => VendorVoucherItem(
                    voucher: ok.data![index],
                    onDeleted: () async {
                      final isConfirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Xác nhận xóa'),
                          content: const Text('Bạn có chắc chắn muốn xóa voucher này không?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      );

                      if (isConfirm ?? false) {
                        final respEither = await sl<VoucherRepository>().updateVoucherStatus(
                          ok.data![index].voucherId!.toString(),
                          Status.DELETED,
                        );
                        respEither.fold(
                          (error) {
                            Fluttertoast.showToast(msg: error.message ?? 'Xóa voucher thất bại!');
                          },
                          (ok) {
                            Fluttertoast.showToast(msg: 'Xóa voucher thành công!');
                            setState(() {});
                          },
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
