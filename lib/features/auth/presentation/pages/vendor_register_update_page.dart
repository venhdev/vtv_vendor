import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/vendor_register_param.dart';
import '../../domain/repository/profile_repository.dart';

//TODO:
// 1. still can change phone....

class VendorRegisterUpdatePage extends StatefulWidget {
  const VendorRegisterUpdatePage({super.key, this.isUpdate = false, this.initParam});

  final bool isUpdate;
  final VendorRegisterParam? initParam;

  @override
  State<VendorRegisterUpdatePage> createState() => _VendorRegisterUpdatePageState();
}

class _VendorRegisterUpdatePageState extends State<VendorRegisterUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late VendorRegisterParam _param;
  late bool _isNetworkImage;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _avatarPath;
  bool changeAvatar = false;
  DateTime? _openTime;
  DateTime? _closeTime;

  // final _addressController = TextEditingController();
  String _wardName = '';
  String _districtName = '';
  String _provinceName = '';
  String _wardCode = '';
  String _address = '';

  FullAddress? fullAddress;
  void handleUpdate() async {
    if (_formKey.currentState!.validate() &&
        _provinceName.isNotEmpty &&
        _districtName.isNotEmpty &&
        _wardName.isNotEmpty &&
        _address.isNotEmpty &&
        (_avatarPath != null || (!changeAvatar && widget.isUpdate))) {
      final VendorRegisterParam param = VendorRegisterParam(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        avatar: _avatarPath!,
        changeAvatar: changeAvatar,
        description: _descriptionController.text,
        openTime: _openTime!,
        closeTime: _closeTime!,
        address: _address,
        wardName: _wardName,
        districtName: _districtName,
        provinceName: _provinceName,
        wardCode: _wardCode,
      );

      log('param: $param');

      final rs = await sl<ProfileRepository>().updateProfile(param);
      rs.fold(
        (error) {
          Fluttertoast.showToast(msg: error.message ?? 'Đã có lỗi xảy ra');
        },
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Cập nhật thành công');
          Navigator.of(context).pop(true);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
        ),
      );
    }
  }

  void handleRegister() async {
    if (_formKey.currentState!.validate() &&
        _provinceName.isNotEmpty &&
        _districtName.isNotEmpty &&
        _wardName.isNotEmpty &&
        _address.isNotEmpty &&
        (_avatarPath != null || (!changeAvatar && widget.isUpdate))) {
      final VendorRegisterParam param = VendorRegisterParam(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        avatar: _avatarPath!,
        changeAvatar: changeAvatar,
        description: _descriptionController.text,
        openTime: _openTime!,
        closeTime: _closeTime!,
        address: _address,
        wardName: _wardName,
        districtName: _districtName,
        provinceName: _provinceName,
        wardCode: _wardCode,
      );

      log('param: $param');

      final rs = await sl<ProfileRepository>().registerVendor(param);
      rs.fold(
        (error) {
          log('error: $error');
          return ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(error.message ?? 'Đã có lỗi xảy ra)'),
            ));
        },
        (ok) {
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     const SnackBar(
          //       content: Text('Đăng ký thành công, vui lòng đăng nhập lại để tiếp tục'),
          //       duration: Duration(seconds: 4),
          //     ),
          //   );
          final auth = context.read<AuthCubit>();
          if (auth.state.status == AuthStatus.authenticated) auth.logout(auth.state.auth!.refreshToken);
          Navigator.of(context).pop(true);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initParam != null) {
      _param = widget.initParam!;
      _nameController.text = _param.name;
      _phoneController.text = _param.phone;
      _emailController.text = _param.email;
      _descriptionController.text = _param.description;
      _avatarPath = _param.avatar;
      _openTime = _param.openTime;
      _closeTime = _param.closeTime;
      _address = _param.address;
      _wardName = _param.wardName;
      _districtName = _param.districtName;
      _provinceName = _param.provinceName;
      _wardCode = _param.wardCode;
      _isNetworkImage = true;
    } else {
      _isNetworkImage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký bán hàng'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ImagePickerBox(
                  imgUrl: _avatarPath,
                  isNetworkImage: _isNetworkImage,
                  onChanged: (newImgPath) {
                    setState(() {
                      _avatarPath = newImgPath;
                      changeAvatar = true;
                      _isNetworkImage = false;
                    });
                  },
                ),
                const SizedBox(height: 8),

                OutlineTextField(
                  controller: _nameController,
                  label: 'Họ và tên',
                ),
                const SizedBox(height: 8),

                // phone
                OutlineTextField(
                  readOnly: widget.initParam != null,
                  controller: _phoneController,
                  label: 'Số điện thoại',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),

                OutlineTextField(
                  readOnly: widget.initParam != null,
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),

                Column(
                  children: [
                    TextButton.icon(
                      label: const Text('Thiết lập địa chỉ'),
                      onPressed: () async {
                        // AddressPickerDialog
                        final addr = await showDialog<FullAddress>(
                          context: context,
                          builder: (context) => AddressPickerDialog(sl: sl),
                        );

                        if (addr != null) {
                          setState(() {
                            fullAddress = addr; // maybe not need all
                            _provinceName = addr.provinceName;
                            _districtName = addr.districtName;
                            _wardName = addr.wardName;
                            _wardCode = addr.wardCode;
                            _address = addr.fullAddress;
                          });
                        }
                      },
                      icon: const Icon(Icons.location_on_outlined),
                    ),
                    _address.isNotEmpty
                        ? Text('Địa chỉ lấy hàng: $_address, $_wardName, $_districtName, $_provinceName')
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 8),

                OutlineTextField(
                  controller: _descriptionController,
                  label: 'Mô tả cửa hàng',
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),

                // open + close time
                openCloseTime(context),
                const SizedBox(height: 16),

                //! register btn
                ElevatedButton(
                  onPressed: widget.initParam == null ? handleRegister : handleUpdate,
                  child: Text(widget.initParam != null ? 'Lưu chỉnh sửa' : 'Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row openCloseTime(BuildContext context) {
    return Row(
      children: [
        // open time
        Expanded(
          child: TextButton(
            child: Text(_openTime != null
                ? 'Giờ mở cửa: ${StringUtils.convertDateTimeToString(_openTime!, pattern: 'hh:mm aa')}'
                : 'Chọn giờ mở cửa'),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (time != null) {
                setState(() {
                  _openTime = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            },
          ),
        ),

        // close time
        Expanded(
          child: TextButton(
            child: Text(_closeTime != null
                ? 'Giờ đóng cửa: ${StringUtils.convertDateTimeToString(_closeTime!, pattern: 'hh:mm aa')}'
                : 'Chọn giờ đóng cửa'),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (time != null) {
                setState(() {
                  _closeTime = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

//*----------------------------------------------------------------------------------------------------*//
