import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';

import '../../domain/entities/dto/product_variant_request.dart';
import '../components/form_add_update_variant.dart';

//! page view to add multiple variant (for each tap it will allow vendor to add/update variant)
class AddUpdateMultiVariantPage extends StatefulWidget {
  const AddUpdateMultiVariantPage({
    super.key,
    required this.initVariants,
    required this.hasAttribute,
    required this.isAdd,
  });

  // final ValueChanged<List<ProductVariantRequest>> onVariantsChanged;
  final List<ProductVariantRequest> initVariants;
  final bool hasAttribute;

  final bool isAdd;

  @override
  State<AddUpdateMultiVariantPage> createState() => _AddUpdateMultiVariantPageState();
}

class _AddUpdateMultiVariantPageState extends State<AddUpdateMultiVariantPage> {
  late List<ProductVariantRequest> _variants;

  bool savedTab = true;

  bool continueCheck() {
    if (savedTab == false) {
      showDialogToConfirm(
        context: context,
        title: 'Nhắc nhở',
        content: 'Bạn phải lưu biến thể hiện tại trước khi xác nhận',
        confirmText: 'Đóng',
        hideDismiss: true,
      );
      return false;
    }
    return _variants.every((variant) {
      if (variant.isValid(hasAttribute: widget.hasAttribute) == false) {
        final msg = variant.isValidMessage(hasAttribute: widget.hasAttribute);
        Fluttertoast.showToast(
            msg:
                'Biển thể${variant.attributeIdentifier.isNotEmpty ? ' "${variant.attributeIdentifier}" ' : ' '}có $msg');
        return false;
      }
      return true;
    });
    //
  }

  @override
  void initState() {
    super.initState();
    _variants = widget.initVariants;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _variants.length,
      child: Builder(builder: (context) {
        final tapController = DefaultTabController.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Biến thể sản phẩm'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  if (continueCheck()) {
                    Navigator.of(context).pop(_variants);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Xác nhận lưu'),
              ),
            ],
            bottom: (_variants.length == 1 && _variants.first.productAttributeRequests.isEmpty)
                ? null
                : TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    controller: DefaultTabController.of(context),
                    onTap: (index) {
                      log('tab index: $index');
                      if (tapController.indexIsChanging) {
                        //> if not saved, prevent user to change tab
                        if (!savedTab) {
                          tapController.animateTo(tapController.previousIndex);
                          showDialogToConfirm(
                            context: context,
                            title: 'Nhắc nhở',
                            content: 'Bạn phải lưu biến thể hiện tại trước khi chuyển sang biến thể khác',
                            confirmText: 'Đóng',
                            hideDismiss: true,
                          );
                        }
                      } else {
                        return;
                      }
                    },
                    tabs: _variants
                        .map(
                          (variant) => Tab(
                            text: variant.attributeIdentifier,
                          ),
                        )
                        .toList(),
                  ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int i = 0; i < _variants.length; i++)
                SingleChildScrollView(
                  child: FormAddUpdateVariant(
                    isAddForm: widget.isAdd,
                    initValue: _variants[i],
                    savedTab: savedTab,
                    onSavedChanged: (isSaved) {
                      savedTab = isSaved;
                    },
                    onVariantChanged: (newVariant) async {
                      if (!mounted) return;
                      setState(() {
                        _variants[i] = newVariant;
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
