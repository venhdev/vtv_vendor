import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/voucher_repository.dart';
import '../components/vendor_voucher_item.dart';

List<String> _filterList = [
  'Trạng thái',
  'Loại voucher',
];

List<Status> _statusList = [
  Status.ACTIVE,
  Status.DELETED,
];

List<VoucherType> _voucherTypeList = [
  VoucherType.MONEY_SHOP,
  VoucherType.PERCENTAGE_SHOP,
];

String _typeName(VoucherType type) {
  switch (type) {
    case VoucherType.MONEY_SHOP:
      return 'Giảm theo tiền';
    case VoucherType.PERCENTAGE_SHOP:
      return 'Giảm theo phần trăm';
    default:
      return 'Unknown type';
  }
}

String _statusName(Status status) {
  switch (status) {
    case Status.ACTIVE:
      return 'Đang hoạt động';
    case Status.DELETED:
      return 'Đã xóa';
    default:
      return 'Unknown status';
  }
}

class VendorVoucherManagePage extends StatefulWidget {
  const VendorVoucherManagePage({super.key});

  @override
  State<VendorVoucherManagePage> createState() => _VendorVoucherManagePageState();
}

class _VendorVoucherManagePageState extends State<VendorVoucherManagePage> {
  bool filterByStatus = true;

  late Status _selectedStatus;
  late VoucherType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedStatus = Status.ACTIVE;
    _selectedType = VoucherType.MONEY_SHOP;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //# type selection
        // dropdown choose type
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Text('Lọc voucher: '),
              const Spacer(),
              DropdownButton<bool>(
                value: filterByStatus,
                items: _filterList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e == _filterList[0],
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    filterByStatus = value!;
                  });
                },
              ),
            ],
          ),
        ),

        Wrap(
            spacing: 8,
            children: filterByStatus
                ? _statusList
                    .map(
                      (e) => ChoiceChip(
                        label: Text(_statusName(e)),
                        selected: _selectedStatus == e,
                        onSelected: (value) {
                          setState(() {
                            _selectedStatus = e;
                          });
                        },
                      ),
                    )
                    .toList()
                : _voucherTypeList
                    .map(
                      (e) => ChoiceChip(
                        label: Text(_typeName(e)),
                        selected: _selectedType == e,
                        onSelected: (value) {
                          setState(() {
                            _selectedType = e;
                          });
                        },
                      ),
                    )
                    .toList()),

        //# voucher list
        Expanded(child: _buildBody()),
      ],
    );
  }

  FutureBuilder<RespData<List<VoucherEntity>>> _buildBody() {
    return FutureBuilder(
      future: filterByStatus
          ? sl<VoucherRepository>().getAllVoucherByStatus(_selectedStatus)
          : sl<VoucherRepository>().getAllVoucherByType(_selectedType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final respEither = snapshot.data!;

          return respEither.fold(
            (error) => MessageScreen.error(error.message),
            (ok) {
              if (ok.data!.isEmpty) {
                return MessageScreen(
                  message: 'Không tìm thấy voucher nào của shop!',
                  onPressed: () => setState(() {}),
                  buttonLabel: 'Tải lại',
                );
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
