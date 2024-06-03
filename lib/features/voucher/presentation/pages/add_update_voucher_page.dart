import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/voucher_repository.dart';

const List<String> _voucherTypes = ['percent', 'money'];

class AddUpdateVoucherPage extends StatefulWidget {
  const AddUpdateVoucherPage({super.key, this.voucher});

  final VoucherEntity? voucher;

  @override
  State<AddUpdateVoucherPage> createState() => _AddUpdateVoucherPageState();
}

class _AddUpdateVoucherPageState extends State<AddUpdateVoucherPage> {
  bool _isLoading = false;
  void showLoading() => {if (mounted) setState(() => _isLoading = true)};
  void hideLoading() => {if (mounted) setState(() => _isLoading = false)};

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _desController = TextEditingController();
  final _discountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late VoucherEntity _voucher;

  late String prefixCode;

  @override
  void initState() {
    super.initState();
    if (widget.voucher != null) {
      //# update voucher
      _voucher = widget.voucher!;
      _codeController.text = _voucher.codeNoPrefix;
      _nameController.text = _voucher.name;
      _desController.text = _voucher.description;
      _discountController.text = ConversionUtils.thousandSeparator(_voucher.discount);
    } else {
      //# add voucher
      _voucher = VoucherEntity.addInit();
      _voucher = _voucher.copyWith(status: Status.ACTIVE);
      _codeController.text = _voucher.code;
      _nameController.text = _voucher.name;
      _desController.text = _voucher.description;
    }
    final username = context.read<AuthCubit>().state.auth!.userInfo.username!;
    prefixCode = '${username.length > 5 ? username.substring(0, 5).toUpperCase() : username.toUpperCase()}-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.voucher != null ? 'Cập nhật Voucher' : 'Thêm Voucher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                //# voucher code
                OutlineTextField(
                  controller: _codeController,
                  // readOnly: widget.voucher != null, // disable editing description when updating voucher
                  inputFormatters: [UpperCaseTextFormatter()],
                  maxLength: 15,
                  label: 'Mã Voucher',
                  prefixText: prefixCode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập mã voucher';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _voucher = _voucher.copyWith(code: value!);
                  },
                ),
                const SizedBox(height: 8.0),

                //# voucher name
                OutlineTextField(
                  controller: _nameController,
                  label: 'Tên Voucher',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập tên voucher';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _voucher = _voucher.copyWith(name: value!);
                  },
                ),
                const SizedBox(height: 8),

                //# voucher description
                OutlineTextField(
                  controller: _desController,
                  label: 'Mô tả',
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập mô tả';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _voucher = _voucher.copyWith(description: value!);
                  },
                ),
                const SizedBox(height: 8),

                //# type (dropdown button)
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    value: _voucher.type == VoucherType.MONEY_SHOP ? 'money' : 'percent',
                    borderRadius: BorderRadius.circular(8.0),
                    onChanged: (value) {
                      setState(() {
                        // _voucher = _voucher.copyWith(type: VoucherTypes.values.byName(value!));
                        if (value == 'percent') {
                          _voucher = _voucher.copyWith(type: VoucherType.PERCENTAGE_SHOP, discount: 10);
                        } else {
                          _voucher = _voucher.copyWith(type: VoucherType.MONEY_SHOP, discount: 1000);
                        }
                      });
                    },
                    items: _voucherTypes.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Row(
                          children: [
                            // Icon(e == VoucherTypes.MONEY_SHOP ? Icons.money_rounded : Icons.percent_rounded),
                            Icon(e == 'percent' ? Icons.percent_rounded : Icons.money_rounded),
                            const SizedBox(width: 4),
                            // Text(StringUtils.getVoucherTypeName(e)),
                            Text(e == 'percent' ? 'Giảm theo %' : 'Giảm theo số tiền'),
                          ],
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Loại',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                //# discount (money or percentage)
                OutlineTextField(
                  inputFormatters: [DecimalFormatter()],
                  controller: _discountController,
                  prefixText: _voucher.type == VoucherType.MONEY_SHOP ? '₫ ' : '% ',
                  label: 'Giảm giá',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập giảm giá';
                    }

                    // remove all ',' in value (format number with comma separator)
                    value = value.replaceAll(',', '');
                    if (int.tryParse(value) == null) {
                      return 'Giảm giá phải là số';
                    } else if (int.tryParse(value)! <= 0) {
                      return 'Giảm giá phải lớn hơn 0';
                    } else if (_voucher.type == VoucherType.PERCENTAGE_SHOP) {
                      if (int.parse(value) > 100) {
                        return 'Giảm giá phải nhỏ hơn 100%';
                      }
                    } else if (_voucher.type == VoucherType.MONEY_SHOP && int.tryParse(value)! < 1000) {
                      return 'Giá trị phải lớn hơn 1.000đ';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    value = value.replaceAll(',', '');
                    log('${int.tryParse(value)}');
                    _voucher = _voucher.copyWith(discount: int.tryParse(value));
                  },
                ),
                const SizedBox(height: 8),

                //# quantity
                OutlineTextField(
                  controller: TextEditingController(text: _voucher.quantity.toString()),
                  label: 'Số lượng',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập số lượng';
                    } else if (int.tryParse(value) == null) {
                      return 'Số lượng phải là số';
                    } else if (int.tryParse(value)! <= 0) {
                      return 'Số lượng phải lớn hơn 0';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _voucher = _voucher.copyWith(quantity: int.tryParse(value));
                  },
                ),
                const SizedBox(height: 8),

                //# start date & end date
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          DateTimeUtils.showDateTimePicker(
                            context: context,
                            initialDateTime: _voucher.startDate,
                            pastDatesEnabled: true,
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                _voucher = _voucher.copyWith(startDate: value);
                              });
                            }
                          });
                        },
                        child: Column(
                          children: [
                            const Text('Ngày bắt đầu'),
                            Text(
                              ConversionUtils.convertDateTimeToString(_voucher.startDate,
                                  pattern: 'dd/MM/yyyy hh:mm aa'),
                            ),
                            Text(
                              DateTimeUtils.getRemainingTime(
                                _voucher.startDate,
                                showOverdueTime: true,
                                prefixRemaining: 'Bắt đầu sau: ',
                              ),
                              style: VTVTheme.hintText12,
                            ),
                            // Text('_voucher.startDate: ${_voucher.startDate}'),
                            // Text('_voucher.startDate isUtc: ${_voucher.startDate.isUtc}'),
                            // Text('_voucher.startDate toUtc: ${_voucher.startDate.toUtc()}'),
                            // Text('_voucher.startDate toLocal: ${_voucher.startDate.toLocal()}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          DateTimeUtils.showDateTimePicker(context: context, initialDateTime: _voucher.endDate)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                _voucher = _voucher.copyWith(endDate: value);
                              });
                            }
                          });
                        },
                        child: Column(
                          children: [
                            const Text('Ngày kết thúc'),
                            Text(ConversionUtils.convertDateTimeToString(_voucher.endDate,
                                pattern: 'dd/MM/yyyy hh:mm:aa')),
                            Text(
                              DateTimeUtils.getRemainingTime(_voucher.endDate, showOverdueTime: true),
                              style: VTVTheme.hintText12,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: handleAddOrUpdateVoucher,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(widget.voucher != null ? 'Cập nhật' : 'Thêm voucher'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleAddOrUpdateVoucher() {
    if (_voucher.startDate.isAfter(_voucher.endDate)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Ngày bắt đầu phải trước ngày kết thúc'),
          ),
        );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.voucher != null) {
        // update voucher

        showLoading();
        _voucher = _voucher.copyWith(
          code: prefixCode + _voucher.code,
        );
        log('Cập nhật voucher: ${_voucher.toJson()}');

        sl<VoucherRepository>().updateVoucher(_voucher).then((respEither) {
          respEither.fold(
            (error) {
              Fluttertoast.showToast(msg: error.message ?? 'Xảy ra lỗi khi cập nhật voucher, vui lòng thử lại sau!');
              // Navigator.pop(context, false);
            },
            (ok) {
              Fluttertoast.showToast(msg: 'Cập nhật voucher thành công');
              Navigator.pop(context, true);
            },
          );
          hideLoading();
        });
      } else {
        // add voucher
        log('Thêm voucher');
        log(_voucher.toMap().toString());

        showLoading();
        _voucher = _voucher.copyWith(
          code: prefixCode + _voucher.code,
        );

        sl<VoucherRepository>().addVoucher(_voucher).then((respEither) {
          respEither.fold(
            (error) {
              Fluttertoast.showToast(msg: error.message ?? 'Xảy ra lỗi khi tạo voucher, vui lòng thử lại sau!');
              // Navigator.pop(context, false);
            },
            (ok) {
              Fluttertoast.showToast(msg: 'Tạo voucher thành công');
              Navigator.pop(context, true);
            },
          );
        });
        hideLoading();
      }
    }
  }
}
