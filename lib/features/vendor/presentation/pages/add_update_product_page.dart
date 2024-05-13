import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/features/vendor/domain/entities/dto/add_and_update_product_param.dart';
import 'package:vendor/features/vendor/presentation/pages/add_update_variants_page.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/dto/product_variant_request.dart';
import '../../domain/repository/vendor_product_repository.dart';
import '../components/add_update_attribute_dialog.dart';
import '../components/add_update_product_field.dart';
import '../components/attribute_controller.dart';
import '../components/category_picker_dialog.dart';

final _emptyVariant = ProductVariantRequest(
  sku: '',
  image: null,
  changeImage: false,
  originalPrice: 0,
  price: 0,
  quantity: 0,
  productAttributeRequests: [],
);

//! validate form bla bla (length, required, etc) --not implemented yet

class AddUpdateProductPage extends StatefulWidget {
  const AddUpdateProductPage({super.key, this.title});

  // style properties
  final String? title;

  @override
  State<AddUpdateProductPage> createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage> {
  final _formKey = GlobalKey<FormState>();

  late AttributeController _attributeController;
  late AddUpdateProductParam _param;

  bool _isValidVariant = false;

  // render
  String renderCategoryName = '';
  String _renderBrandName = '';
  // int _numberOfVariants = 1;

  void updateAttribute() {
    setState(() {
      if (_attributeController.totalVariantCount == 0) {
        _param = _param.copyWith(productVariantRequests: [_emptyVariant]);
      } else {
        _param = _param.copyWith(
          productVariantRequests: _attributeController.allVariantAttributes
              .map((attributes) => ProductVariantRequest(
                    sku: '',
                    image: null,
                    changeImage: false,
                    originalPrice: 0,
                    price: 0,
                    quantity: 0,
                    productAttributeRequests: attributes,
                  ))
              .toList(),
        );
      }

      _isValidVariant = false;
    });
  }

  Future<void> handleUpdateVariant() async {
    log('_attributeController.totalGroupCount > 0: ${_attributeController.totalGroupCount > 0}');
    final newVariants = await Navigator.of(context).push<List<ProductVariantRequest>>(
      MaterialPageRoute(
        builder: (context) {
          return AddUpdateMultiVariantPage(
            initVariants: _param.productVariantRequests,
            hasAttribute: _attributeController.totalGroupCount > 0,
            isEdit: false,
          );
        },
      ),
    );

    if (newVariants != null) {
      setState(() {
        //! this 'newVariants' is valid >> already checked in AddUpdateMultiVariantPage before return
        _isValidVariant = true;
        _param = _param.copyWith(productVariantRequests: newVariants);
      });
    } else {
      if (_isValidVariant == true) return; //> do nothing when user cancel && variant is already valid
      setState(() {
        _isValidVariant = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _param = AddUpdateProductParam(
      name: '',
      image: null,
      changeImage: false,
      description: '',
      information: '',
      categoryId: 0,
      productVariantRequests: <ProductVariantRequest>[
        _emptyVariant,
      ],
    );
    _attributeController = AttributeController({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Thêm sản phẩm mới'),
      ),
      body: SingleChildScrollView(
        child: Wrapper(
          label: const WrapperLabel(icon: Icons.info, labelText: 'Thông tin sản phẩm'),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //# product image
                ImagePickerBox(
                  imgUrl: _param.image,
                  size: 120.0,
                  onChanged: (newImageUrl) {
                    _param = _param.copyWith(image: newImageUrl, changeImage: true);
                  },
                ),
                const SizedBox(height: 12.0),

                //# product name
                OutlineTextField(
                  label: 'Tên sản phẩm',
                  maxLines: 1,
                  onChanged: (value) {
                    _param = _param.copyWith(name: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập tên sản phẩm';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                //# product information
                OutlineTextField(
                  label: 'Thông tin sản phẩm',
                  isRequired: true,
                  maxLines: 4,
                  onChanged: (value) {
                    // _param.information = value;
                    _param = _param.copyWith(information: value);
                  },
                ),
                const SizedBox(height: 12.0),

                //# product description
                OutlineTextField(
                  label: 'Mô tả sản phẩm',
                  maxLines: 4,
                  onChanged: (value) {
                    // _param.description = value;
                    _param = _param.copyWith(description: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập mô tả sản phẩm';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                //# product category
                AddUpdateProductField(
                  isRequired: true,
                  suffixIcon: const Icon(Icons.edit),
                  onPressed: () async {
                    final category = await showDialog<CategoryEntity>(
                      context: context,
                      builder: (context) => const CategoryPickerDialog(),
                    );

                    if (category != null) {
                      setState(() {
                        // _param.categoryId = category.categoryId;
                        _param = _param.copyWith(categoryId: category.categoryId);
                        renderCategoryName = category.name;
                      });
                    }
                  },
                  child: Text('Danh mục: $renderCategoryName', style: const TextStyle(fontSize: 16)),
                ),

                //# product brand
                AddUpdateProductField(
                  isRequired: false,
                  suffixIcon: const Icon(Icons.edit),
                  onPressed: () async {
                    // final brand = await showDialog<BrandEntity>(
                    //   context: context,
                    //   builder: (context) => const BrandPickerDialog(),
                    // );

                    // if (brand != null) {
                    //   setState(() {
                    //     _param.brandId = brand.brandId;
                    //     _renderCategoryName = brand.name;
                    //   });
                    // }
                  },
                  child: Text(
                    'Thương hiệu: ${_renderBrandName.isEmpty ? '(chưa chọn)' : renderCategoryName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                //# variants form
                Wrapper(
                  label: const WrapperLabel(icon: Icons.view_comfy_alt, labelText: 'Biến thể sản phẩm'),
                  crossAxisAlignment: CrossAxisAlignment.end,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      //# add attribute
                      attributeController(context),

                      Wrapper(
                        useBoxShadow: false,
                        label: _isValidVariant
                            ? const WrapperLabel(
                                icon: Icons.done,
                                iconColor: Colors.green,
                                labelText: 'Biến thể hợp lệ',
                              )
                            : const WrapperLabel(
                                icon: Icons.warning_rounded,
                                iconColor: Colors.red,
                                labelText: 'Biến thể chưa hợp lệ',
                              ),
                        suffixLabel: //# set variant button
                            TextButton(
                          onPressed: () async => await handleUpdateVariant(),
                          child: const Text('Cài đặt biến thể'),
                        ),
                      ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: _param.productVariantRequests.length,
                      //   itemBuilder: (context, index) {
                      //     return Wrapper(
                      //       useBoxShadow: false,
                      //       label: WrapperLabel(labelText: 'Biến thể ${index + 1}'),
                      //       child: FormAddUpdateVariant(
                      //         initValue: _param.productVariantRequests[index],
                      //         onChanged: (variant) {
                      //           _param.productVariantRequests[index] = variant;
                      //         },
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),

                const Divider(),
                _isValidVariant
                    ? ElevatedButton(
                        onPressed: _param.productVariantRequests.length == _attributeController.totalVariantCount
                            ? () async {
                                final respEither = await sl<VendorProductRepository>().addProduct(_param);

                                respEither.fold(
                                  (error) {
                                    Fluttertoast.showToast(msg: error.message ?? 'Thêm sản phẩm thất bại');
                                  },
                                  (ok) {
                                    Fluttertoast.showToast(msg: ok.message ?? 'Thêm sản phẩm thành công');
                                  },
                                );
                              }
                            : null,
                        child: const Text('Thêm sản phẩm'),
                      )
                    : const Text('Vui lòng nhập đủ thông tin biến thể sản phẩm'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget attributeController(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(children: [
        //# action bar
        Row(
          children: [
            Text('Danh sách thuộc tính ${'(${_attributeController.totalGroupCount})'}'),
            const Spacer(),
            IconButton(
              onPressed: () async {
                final isConfirmChange = await showDialogToConfirm<bool>(
                  context: context,
                  title: 'Lưu ý',
                  content:
                      'Khi thêm danh sách thuộc tính, toàn bộ biến thể sẽ bị thay đổi. Những cài đặt trước đó (nếu có) sẽ bị mất , bạn có chắc chắn muốn thêm thuộc tính mới không?',
                  confirmText: 'Thêm',
                  dismissText: 'Hủy bỏ',
                );

                if ((isConfirmChange ?? false) && context.mounted) {
                  final rs = await showDialog<Map<String, List<String>>>(
                    context: context,
                    builder: (context) {
                      return const AddUpdateAttributeDialog();
                    },
                  );

                  if (rs != null) {
                    log('rs: $rs');
                    _attributeController.addGroupAttribute(rs);
                    updateAttribute();
                  }
                }
              },
              icon: const Icon(Icons.my_library_add),
            ),
          ],
        ),
        //# list of attributes
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _attributeController.totalGroupCount,
          itemBuilder: (context, index) {
            final group = _attributeController.attributeGroups.keys.elementAt(index);
            final attributes = _attributeController.attributeGroups[group]!;

            return Column(
              children: [
                Text(group),
                Wrap(
                  children: attributes
                      .map((attribute) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Chip(
                              label: Text(attribute),
                              onDeleted: () async {
                                final isConfirmDelete = await showDialogToConfirm<bool>(
                                  context: context,
                                  title: 'Lưu ý',
                                  content:
                                      'Khi xóa thuộc tính, toàn bộ biến thể sẽ bị xóa. Bạn có chắc chắn muốn xóa không?',
                                  confirmText: 'xóa',
                                  dismissText: 'Hủy bỏ',
                                );

                                if (isConfirmDelete ?? false) {
                                  _attributeController.removeAttributeAt(group, attribute);
                                  updateAttribute();
                                }
                              },
                            ),
                          ))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ]),
    );
  }
}
