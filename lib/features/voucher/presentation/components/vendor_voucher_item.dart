import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../pages/add_update_voucher_page.dart';

class VendorVoucherItem extends StatelessWidget {
  const VendorVoucherItem({super.key, required this.voucher, required this.onDeleted});

  final VoucherEntity voucher;
  final Future<void> Function() onDeleted;

//   final int? voucherId;
//   final Status status;
//   final String code;
  Future<void> editPressed(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AddUpdateVoucherPage(voucher: voucher);
        },
      ),
    );
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
            Row(
              children: [
                Column(
                  children: [
                    Icon(
                      voucher.type == VoucherTypes.MONEY_SHOP ? Icons.money : Icons.percent_rounded,
                      color: voucher.type == VoucherTypes.MONEY_SHOP ? Colors.green : Colors.blue,
                    ),
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: voucher.type == VoucherTypes.MONEY_SHOP ? 'Giảm tiền\n' : 'Phần trăm\n',
                        children: [
                          TextSpan(
                            text: voucher.type == VoucherTypes.MONEY_SHOP
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
            ),

            //# start-end date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('voucher.startDate isUTC: ${voucher.startDate.isUtc} -> ${voucher.startDate.toIso8601String()}'),
                // Text('UTC time: ${voucher.startDate.toUtc()}'),
                // Text('Local Time: ${voucher.startDate.toLocal()}'),
                // Text('now isUtc: ${DateTime.now().isUtc}'),
                // Text('now: ${DateTime.now()} - utcNow: ${DateTime.now().toUtc()}\n\n\n.'),
                // SelectableText('nowIso8601: ${DateTime.now().toIso8601String()}\nutcNow: ${DateTime.now().toUtc().toIso8601String()}\n\n\n.'),
                // const Divider(),

                Text.rich(
                  TextSpan(
                      text:
                          'Ngày bắt đầu: ${ConversionUtils.convertDateTimeToString(voucher.startDate, pattern: 'dd/MM/yyyy hh:mm aa')} ',
                      children: [
                        if (voucher.status == Status.ACTIVE && DateTime.now().isBefore(voucher.endDate))
                          TextSpan(
                            style: VTVTheme.hintTextStyle,
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
                            style: VTVTheme.hintTextStyle,
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
              style: VTVTheme.hintTextMediumStyle,
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
                    style: VTVTheme.hintTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // edit TextButton.icon
                TextButton.icon(
                  onPressed: () => editPressed(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Sửa'),
                ),

                // delete TextButton.icon
                TextButton.icon(
                  onPressed: onDeleted,
                  icon: const Icon(Icons.delete),
                  label: const Text('Xóa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
