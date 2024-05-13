import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';

import '../../domain/entities/dto/product_variant_request.dart';

class FormAddUpdateVariant extends StatefulWidget {
  const FormAddUpdateVariant({
    super.key,
    required this.onVariantChanged,
    required this.initValue,
    required this.isAddForm,
    required this.savedTab,
    required this.onSavedChanged,
  });

  final ProductVariantRequest initValue;
  final bool isAddForm; //? if true, this form used for add new variant >> required image first time
  final ValueChanged<ProductVariantRequest> onVariantChanged;
  final bool savedTab;
  final ValueChanged<bool> onSavedChanged;

  @override
  State<FormAddUpdateVariant> createState() => _FormAddUpdateVariantState();
}

class _FormAddUpdateVariantState extends State<FormAddUpdateVariant> {
  final _formKey = GlobalKey<FormState>();
  late ProductVariantRequest _variantParam;

  late bool _saved;

  void handleEditing() {
    if (!mounted) return;
    setState(() {
      if (_saved == false) return;
      _saved = false;
      widget.onSavedChanged(_saved);
    });
  }

  void handleSaved() {
    if (!mounted) return;
    if (_formKey.currentState!.validate() == false) return;
    final msgValid = _variantParam.isValidMessage(
      imageRequired: widget.isAddForm,
      hasAttribute: widget.initValue.productAttributeRequests.isNotEmpty,
    );
    if (msgValid != '') {
      Fluttertoast.showToast(msg: msgValid);
      return;
    }

    setState(() {
      if (_saved == true) return;
      _saved = true;
      widget.onSavedChanged(_saved);
      widget.onVariantChanged(_variantParam);
    });
  }

  @override
  void initState() {
    super.initState();
    // log('widget.initValue.sku: ${widget.initValue.sku}');
    // log('widget.initValue.hashCode: ${widget.initValue.hashCode}');
    _variantParam = widget.initValue;

    _saved = widget.savedTab;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // IconButton(
          //   onPressed: () {
          //     log('--before change savedTab hasCode: ${_unsaved.hashCode} || value savedTab: $_unsaved');
          //     _unsaved = !_unsaved;
          //     widget.onSavedChanged(_unsaved);
          //     log('--after change savedTab hasCode: ${_unsaved.hashCode} || value savedTab: $_unsaved');
          //   },
          //   icon: const Icon(Icons.add),
          // ),
          // IconButton(
          //   onPressed: () {
          //     log('savedTab hasCode: ${_unsaved.hashCode} || value savedTab: $_unsaved');
          //   },
          //   icon: const Icon(Icons.logo_dev),
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // onPressed: () {
              //   log('save');
              //   setState(() {
              //     if (_formKey.currentState!.validate()) {
              //       widget.onVariantChanged(_variantParam);
              //       _isEditing = false;
              //     }
              //   });
              // },
              if (!_saved) ...[
                TextButton.icon(
                  onPressed: null,
                  label: const Text('Đang sửa'),
                  icon: const Icon(Icons.edit_note, color: Colors.grey),
                ),
                TextButton.icon(
                  label: const Text('Lưu'),
                  onPressed: () => handleSaved(),
                  icon: const Icon(Icons.save),
                )
              ] else ...[
                TextButton.icon(
                  onPressed: null,
                  label: const Text('Đã lưu'),
                  icon: const Icon(Icons.done, color: Colors.grey),
                ),
                TextButton.icon(
                  label: const Text('Bắt đầu sửa'),
                  onPressed: () => handleEditing(),
                  icon: const Icon(Icons.edit),
                )
              ],
            ],
          ),

          IgnorePointer(
            ignoring: _saved,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //# variant image
                  ImagePickerBox(
                    imgUrl: _variantParam.image,
                    size: 120.0,
                    onChanged: (newImageUrl) {
                      _variantParam = _variantParam.copyWith(image: newImageUrl, changeImage: true);
                    },
                  ),
                  const SizedBox(height: 8),

                  //# sku
                  OutlineTextField(
                    label: 'SKU',
                    controller: TextEditingController(text: _variantParam.sku.isNotEmpty ? _variantParam.sku : null),
                    // onFieldSubmitted: (value) {
                    //   if (_formKey.currentState!.validate()) {
                    //     widget.onVariantChanged(_variantParam);
                    //     if (_isEditing && mounted) {
                    //       setState(() {
                    //         _isEditing = false;
                    //       });
                    //     }
                    //   }
                    // },
                    onChanged: (value) {
                      _variantParam = _variantParam.copyWith(sku: value);
                      // widget.onChanged(_variantParam);
                    },
                  ),
                  const SizedBox(height: 8),

                  //# original price
                  OutlineTextField(
                    label: 'Giá gốc',
                    controller: TextEditingController(
                      text: _variantParam.originalPrice != 0 ? _variantParam.originalPrice.toString() : null,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _variantParam = _variantParam.copyWith(originalPrice: int.tryParse(value) ?? 0);
                      // widget.onChanged(_variantParam);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Giá gốc không được để trống';
                      } else if (int.tryParse(value) == null) {
                        return 'Giá gốc không hợp lệ';
                      } else if (int.tryParse(value)!.isNegative) {
                        return 'Giá gốc không được âm';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  //# price
                  OutlineTextField(
                    label: 'Giá bán',
                    controller: TextEditingController(
                      text: _variantParam.price != 0 ? _variantParam.price.toString() : null,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _variantParam = _variantParam.copyWith(price: int.tryParse(value) ?? 0);
                      // widget.onChanged(_variantParam);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Giá bán không được để trống';
                      } else if (int.tryParse(value) == null) {
                        return 'Giá bán không hợp lệ';
                      } else if (int.tryParse(value)!.isNegative) {
                        return 'Giá bán không được âm';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  //# quantity
                  OutlineTextField(
                    label: 'Số lượng',
                    controller: TextEditingController(
                      text: _variantParam.quantity != 0 ? _variantParam.quantity.toString() : null,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // _variantParam.quantity = int.tryParse(value) ?? 0;
                      _variantParam = _variantParam.copyWith(quantity: int.tryParse(value) ?? 0);
                      // widget.onChanged(_variantParam);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Số lượng không được để trống';
                      } else if (int.tryParse(value) == null) {
                        return 'Số lượng không hợp lệ';
                      } else if (int.tryParse(value)!.isNegative) {
                        return 'Số lượng không được âm';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
