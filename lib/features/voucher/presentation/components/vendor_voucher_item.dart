import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../pages/add_update_voucher_page.dart';

class VendorVoucherItem extends StatelessWidget {
  const VendorVoucherItem({
    super.key,
    required this.voucher,
    required this.onDeleted,
    required this.refreshCallback,
  });

  final VoucherEntity voucher;
  final Future<void> Function() onDeleted;

  // control
  final VoidCallback refreshCallback;

//   final int? voucherId;
//   final Status status;
//   final String code;
  Future<void> editPressed(BuildContext context) async {
    final shouldReload = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddUpdateVoucherPage(voucher: voucher);
        },
      ),
    );

    if (shouldReload == true) {
      refreshCallback();
    }
  }

  String _voucherStatusName() {
    return (voucher.status == Status.ACTIVE)
        ? voucher.startDate.isAfter(DateTime.now())
            ? 'Đang hoạt động (Chưa bắt đầu)' // it's not started yet
            : voucher.endDate.isBefore(DateTime.now())
                ? 'Hết hạn' // it's expired
                : 'Đang hoạt động (Đang diễn ra)' // it's active
        : (voucher.status == Status.DELETED) // it's expired or disabled
            ? 'Đã xóa'
            : (voucher.status == Status.INACTIVE)
                ? 'Không hoạt động'
                : 'Unknown voucher status';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (voucher.status == Status.ACTIVE)
          ? voucher.startDate.isAfter(DateTime.now())
              ? Colors.blue.shade50 // it's not started yet
              : voucher.endDate.isBefore(DateTime.now())
                  ? Colors.red.shade50 // it's expired
                  : Colors.green.shade50 // it's active
          : Colors.red.shade50, // it's expired or disabled
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //# voucher info
            voucherInfo(),

            const Divider(),
            Text('Trạng thái: ${_voucherStatusName()}'),

            //# start-end date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text:
                          'Ngày bắt đầu: ${ConversionUtils.convertDateTimeToString(voucher.startDate, pattern: 'dd/MM/yyyy hh:mm aa')} ',
                      children: [
                        if (voucher.status == Status.ACTIVE && DateTime.now().isBefore(voucher.endDate))
                          TextSpan(
                            style: VTVTheme.hintText12,
                            text: '(${DateTimeUtils.getRemainingTime(
                              showOverdueTime: true,
                              voucher.startDate,
                              prefixRemaining: 'Bắt đầu sau: ',
                              prefixOverdue: 'Đã bắt đầu: ',
                            )})',
                          ),
                      ]),
                ),
                // Text(
                //   'Ngày kết thúc: ${ConversionUtils.convertDateTimeToString(voucher.endDate, pattern: 'dd/MM/yyyy HH:mm')} (${DateTimeUtils.getRemainingTime(voucher.endDate)})',
                // ),
                Text.rich(
                  TextSpan(
                      text:
                          'Ngày kết thúc: ${ConversionUtils.convertDateTimeToString(voucher.endDate, pattern: 'dd/MM/yyyy hh:mm aa')} ',
                      children: [
                        if (voucher.status == Status.ACTIVE)
                          TextSpan(
                            style: VTVTheme.hintText12,
                            text: '(${DateTimeUtils.getRemainingTime(
                              showOverdueTime: true,
                              voucher.endDate,
                              prefixRemaining: 'Kết thúc sau: ',
                              prefixOverdue: 'Đã kết thúc: ',
                            )})',
                          ),
                      ]),
                ),
              ],
            ),
            const SizedBox(height: 8),

            //# progress bar
            LinearProgressIndicator(
              value: voucher.quantityUsed! / voucher.quantity,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              semanticsLabel: "Voucher Progress Bar",
            ),
            Text(
              '${voucher.quantityUsed!}/${voucher.quantity} - Đã dùng ${(voucher.quantityUsed! / voucher.quantity * 100).toInt()}%',
              style: VTVTheme.hintText13,
              textAlign: TextAlign.end,
            ),

            //# action button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // copy code icon button + hint small code text
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: voucher.code));
                    Fluttertoast.showToast(msg: 'Đã sao chép mã voucher');
                  },
                  icon: const Icon(Icons.copy),
                ),
                Expanded(
                  child: Text(
                    voucher.code,
                    style: VTVTheme.hintText12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // edit TextButton.icon
                if (voucher.status == Status.ACTIVE && voucher.quantityUsed == 0) ...[
                  TextButton.icon(
                    onPressed: () => editPressed(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Sửa'),
                  ),
                ],

                if (voucher.status != Status.DELETED) ...[
                  TextButton.icon(
                    onPressed: onDeleted,
                    icon: const Icon(Icons.delete),
                    label: const Text('Xóa'),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row voucherInfo() {
    return Row(
      children: [
        Column(
          children: [
            Icon(
              voucher.type == VoucherType.MONEY_SHOP ? Icons.money : Icons.percent_rounded,
              color: voucher.type == VoucherType.MONEY_SHOP ? Colors.green : Colors.blue,
            ),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: voucher.type == VoucherType.MONEY_SHOP ? 'Giảm tiền\n' : 'Phần trăm\n',
                children: [
                  TextSpan(
                    text: voucher.type == VoucherType.MONEY_SHOP
                        ? ConversionUtils.formatCurrency(voucher.discount)
                        : '${voucher.discount}%',
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: ListTile(
            title: Text(voucher.name, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            subtitle: Text(voucher.description),
          ),
        ),
      ],
    );
  }
}
