import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/features/vendor/domain/entities/dto/add_and_update_product_param.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/dto/product_attribute_request.dart';
import '../../domain/entities/dto/product_variant_request.dart';
import '../../domain/repository/vendor_product_repository.dart';
import '../components/category_picker_dialog.dart';

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

  // render
  String _renderCategoryName = '';
  String _renderBrandName = '';
  // int _numberOfVariants = 1;

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
    _attributeController = AttributeController(ActionType.unknown, '', []);
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
                    _param.image = newImageUrl;
                    _param.changeImage = true;
                  },
                ),
                const SizedBox(height: 12.0),

                //# product name
                OutlineTextField(
                  label: 'Tên sản phẩm',
                  onChanged: (value) {
                    _param.name = value;
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
                  onChanged: (value) {
                    _param.information = value;
                  },
                  label: 'Thông tin sản phẩm',
                  isRequired: true,
                ),
                const SizedBox(height: 12.0),

                //# product description
                OutlineTextField(
                  label: 'Mô tả sản phẩm',
                  onChanged: (value) {
                    _param.description = value;
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
                  isRequired: false,
                  suffixIcon: const Icon(Icons.edit),
                  onPressed: () async {
                    final category = await showDialog<CategoryEntity>(
                      context: context,
                      builder: (context) => const CategoryPickerDialog(),
                    );

                    if (category != null) {
                      setState(() {
                        _param.categoryId = category.categoryId;
                        _renderCategoryName = category.name;
                      });
                    }
                  },
                  child: Text('Danh mục: $_renderCategoryName', style: const TextStyle(fontSize: 16)),
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
                    'Thương hiệu: ${_renderBrandName.isEmpty ? '(chưa chọn)' : _renderCategoryName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                //# variants form
                Wrapper(
                  label: const WrapperLabel(icon: Icons.view_comfy_alt, labelText: 'Biến thể sản phẩm'),
                  crossAxisAlignment: CrossAxisAlignment.end,
                  bottom: TextButton.icon(
                    label: const Text('Thêm biến thể'),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _param.productVariantRequests.add(_emptyVariant);
                      });
                    },
                  ),
                  child: Column(
                    children: [
                      Text('Test count up: ${_attributeController.testCountUp}'),
                      Text('Test count down: ${_attributeController.testCountDown}'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(children: [
                          Row(
                            children: [
                              Text('Danh sách thuộc tính ${'(${_attributeController.attributes.length})'}'),
                              const Spacer(),
                              IconButton(
                                onPressed: () async {
                                  final attribute = await showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      final TextEditingController attributeController = TextEditingController();
                                      return AlertDialog(
                                        title: const Text('Thêm thuộc tính mới'),
                                        content: TextField(
                                          autofocus: true,
                                          controller: attributeController,
                                          onSubmitted: (value) {
                                            Navigator.of(context).pop(value);
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Hủy'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(attributeController.text);
                                            },
                                            child: const Text('Thêm'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (attribute != null && attribute.isNotEmpty) {
                                    setState(() {
                                      _attributeController.addAttribute(attribute);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.my_library_add),
                              ),
                            ],
                          ),
                          for (var attribute in _attributeController.attributes)
                            Row(
                              children: [
                                Text(attribute),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _attributeController.removeAttribute(attribute);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                        ]),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          log('${_param.productVariantRequests[0].hashCode}');
                          log('productVariantRequests: ${_param.productVariantRequests[0]}');
                        },
                        child: const Text('Button'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _param.productVariantRequests.length,
                        itemBuilder: (context, index) {
                          return Wrapper(
                            useBoxShadow: false,
                            label: WrapperLabel(labelText: 'Biến thể ${index + 1}'),
                            child: FormAddUpdateVariant(
                              initValue: _param.productVariantRequests[index],
                              attributeController: _attributeController,
                              onChanged: (variant) {
                                _param.productVariantRequests[index] = variant;
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Divider(),
                ElevatedButton(
                  onPressed: () async {
                    final respEither = await sl<VendorProductRepository>().addProduct(_param);

                    respEither.fold(
                      (error) {
                        Fluttertoast.showToast(msg: error.message ?? 'Thêm sản phẩm thất bại');
                      },
                      (ok) {
                        Fluttertoast.showToast(msg: ok.message ?? 'Thêm sản phẩm thành công');
                      },
                    );
                  },
                  child: const Text('Thêm sản phẩm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddUpdateProductField extends StatelessWidget {
  const AddUpdateProductField({
    super.key,
    required this.isRequired,
    this.onPressed,
    required this.suffixIcon,
    required this.child,
  });

  final bool isRequired;
  final VoidCallback? onPressed;
  final Widget suffixIcon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isRequired) const Text('* ', style: TextStyle(color: Colors.red)),
        Expanded(child: child),
        IconButton(
          onPressed: onPressed,
          icon: suffixIcon,
        ),
      ],
    );
  }
}

class FormAddUpdateVariant extends StatefulWidget {
  const FormAddUpdateVariant({
    super.key,
    required this.onChanged,
    required this.initValue,
    required this.attributeController,
  });

  // int? productVariantId; --null when add
  // String sku;
  // String? image; --required when add & set changeImage = true
  // bool changeImage; --required when add = true, when update can be false
  // int originalPrice;
  // int price;
  // int quantity;
  // List<ProductAttributeRequest> productAttributeRequests;

  final ProductVariantRequest initValue;
  final AttributeController attributeController;
  final ValueChanged<ProductVariantRequest> onChanged;

  @override
  State<FormAddUpdateVariant> createState() => _FormAddUpdateVariantState();
}

class _FormAddUpdateVariantState extends State<FormAddUpdateVariant> {
  late ProductVariantRequest _variantParam;
  late List<String> _attributes;

  @override
  void initState() {
    super.initState();
    log('[FormAddUpdateVariant] init state');
    _variantParam = widget.initValue;
    _attributes = widget.attributeController.attributes;

    // widget.attributeController.addListener(() {
    //   if (!mounted) return;

    //   if (widget.attributeController.type == ActionType.add) {
    //     setState(() {
    //       _attributes.add(widget.attributeController.recentAttribute);
    //     });
    //   } else if (widget.attributeController.type == ActionType.delete) {
    //     setState(() {
    //       _attributes.remove(widget.attributeController.recentAttribute);
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      backgroundColor: Colors.orange.shade50,
      child: Column(
        children: [
          //dev
          ElevatedButton(
            onPressed: () {
              log('${_variantParam.hashCode}');
              log('_variantParam: ${_variantParam}');
            },
            child: const Text('variant hashCode'),
          ),
          //# variant image
          ImagePickerBox(
            imgUrl: _variantParam.image,
            size: 120.0,
            onChanged: (newImageUrl) {
              _variantParam.image = newImageUrl;
              _variantParam.changeImage = true;
              widget.onChanged(_variantParam);
            },
          ),
          const SizedBox(height: 8),

          //# sku
          OutlineTextField(
            label: 'SKU',
            onChanged: (value) {
              _variantParam.sku = value;
              widget.onChanged(_variantParam);
            },
          ),
          const SizedBox(height: 8),

          //# original price
          OutlineTextField(
            label: 'Giá gốc',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _variantParam.originalPrice = int.parse(value);
              widget.onChanged(_variantParam);
            },
          ),
          const SizedBox(height: 8),

          //# price
          OutlineTextField(
            label: 'Giá bán',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _variantParam.price = int.parse(value);
              widget.onChanged(_variantParam);
            },
          ),
          const SizedBox(height: 8),

          //# quantity
          OutlineTextField(
            label: 'Số lượng',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _variantParam.quantity = int.parse(value);
              widget.onChanged(_variantParam);
            },
          ),
          const SizedBox(height: 8),

          //# attribute value (productAttributeRequests)
          Wrapper(
            backgroundColor: Colors.blue.shade50,
            label: const WrapperLabel(icon: Icons.list, labelText: 'Thuộc tính của biến thể'),
            suffixLabel: IconButton(
              onPressed: () {
                widget.attributeController.addAttribute('Thuộc tính mới');
              },
              icon: const Icon(Icons.edit),
            ),
            crossAxisAlignment: CrossAxisAlignment.start,
            child: Column(
              children: [
                for (int i = 0; i < _attributes.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlineTextField(
                      label: _attributes[i],
                      onChanged: (value) {},
                      onFieldSubmitted: (value) {
                        log('onFieldSubmitted: $value');
                        final productAttribute = ProductAttributeRequest(
                          name: _attributes[i],
                          value: value,
                        );

                        _variantParam.productAttributeRequests.add(productAttribute);
                        widget.onChanged(_variantParam);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePickerBox extends StatefulWidget {
  const ImagePickerBox({super.key, required this.imgUrl, this.onChanged, this.size = 120.0});

  final String? imgUrl;
  final ValueChanged<String>? onChanged;
  final double size;

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  String? _imgUrl;

  @override
  void initState() {
    super.initState();
    _imgUrl = widget.imgUrl;
  }

  @override
  Widget build(BuildContext context) {
    return _imgUrl != null
        ? InkWell(
            onTap: () async {
              await FileUtils.showImagePicker().then((value) {
                if (value != null) {
                  setState(() {
                    _imgUrl = value.path;
                    // _param.changeImage = true;
                  });
                  widget.onChanged?.call(value.path);
                }
              });
            },
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.all(4),
              height: widget.size,
              width: widget.size,
              child: Image.file(File(_imgUrl!)),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
            ),
            height: widget.size,
            width: widget.size,
            child: IconButton(
              onPressed: () async {
                await FileUtils.showImagePicker().then((value) {
                  if (value != null) {
                    setState(() {
                      _imgUrl = value.path;
                      // _param.changeImage = true;
                    });
                    widget.onChanged?.call(value.path);
                  }
                });
              },
              icon: const Icon(Icons.add_a_photo),
              iconSize: 24,
            ),
          );
  }
}

enum ActionType { add, update, delete, unknown } //TODO move to common

class AttributeController extends ChangeNotifier {
  AttributeController(
    this.type,
    this.recentAttribute,
    List<String> attributes,
  ) : _attributes = attributes;

  final List<String> _attributes;
  List<String> get attributes => _attributes;

  ActionType type;
  String recentAttribute;

  int testCountUp = 0;
  int testCountDown = 0;

  void addAttribute(String attribute) {
    _attributes.add(attribute);
    type = ActionType.add;
    recentAttribute = attribute;
    testCountUp++;
    notifyListeners();
  }

  void removeAttribute(String attribute) {
    _attributes.remove(attribute);
    type = ActionType.delete;
    recentAttribute = attribute;
    testCountDown++;
    notifyListeners();
  }
}

final _emptyVariant = ProductVariantRequest(
  sku: '',
  image: null,
  changeImage: false,
  originalPrice: 0,
  price: 0,
  quantity: 0,
  productAttributeRequests: [],
);
