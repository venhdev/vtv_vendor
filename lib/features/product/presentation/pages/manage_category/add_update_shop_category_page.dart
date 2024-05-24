import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/shop.dart';

import '../../../../../service_locator.dart';
import '../../../domain/entities/dto/add_update_shop_category_request.dart';
import '../../../domain/repository/vendor_product_repository.dart';

class AddUpdateShopCategoryPage extends StatefulWidget {
  const AddUpdateShopCategoryPage({super.key, this.shopCategory});

  final ShopCategoryEntity? shopCategory;

  @override
  State<AddUpdateShopCategoryPage> createState() => _AddUpdateShopCategoryPageState();
}

class _AddUpdateShopCategoryPageState extends State<AddUpdateShopCategoryPage> {
  final TextEditingController _nameController = TextEditingController();

  late AddUpdateShopCategoryRequest request;
  late bool _isNetworkImage;

  @override
  void initState() {
    super.initState();
    if (widget.shopCategory == null) {
      request = AddUpdateShopCategoryRequest.addInit();
      _isNetworkImage = false;
    } else {
      request = AddUpdateShopCategoryRequest.updateFrom(
        name: widget.shopCategory!.name,
        changeImage: false,
        image: widget.shopCategory!.image,
      );
      _nameController.text = widget.shopCategory!.name;
      _isNetworkImage = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleAddUpdateCategory() async {
    log('request: ${request.toString()}');
    if (_nameController.text == '') {
      Fluttertoast.showToast(msg: 'Vui lòng nhập tên danh mục');
      return;
    }
    request = request.copyWith(name: _nameController.text);

    if (widget.shopCategory != null) {
      //> update
      final respEither = await sl<VendorProductRepository>().updateShopCategory(
        widget.shopCategory!.categoryShopId,
        request,
      );
      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Cập nhật danh mục không thành công'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Cập nhật danh mục thành công');
          Navigator.of(context).pop(true);
        },
      );
    } else {
      //> add
      if (!request.changeImage || request.image == null || request.image!.isEmpty) {
        Fluttertoast.showToast(msg: 'Vui lòng chọn ảnh danh mục');
        return;
      }

      final respEither = await sl<VendorProductRepository>().addShopCategory(request);
      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Thêm danh mục không thành công'),
        (ok) {
          Fluttertoast.showToast(msg: ok.message ?? 'Thêm danh mục thành công');
          Navigator.of(context).pop(true);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopCategory != null ? 'Chỉnh sửa danh mục' : 'Thêm danh mục'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //# image picker
            ImagePickerBox(
              imgUrl: request.image,
              isNetworkImage: _isNetworkImage,
              onChanged: (value) {
                if (widget.shopCategory != null) {
                  setState(() {
                    request = request.copyWith(changeImage: true, image: value);
                    _isNetworkImage = false;
                  });
                } else {
                  request = request.copyWith(image: value);
                }
              },
            ),
            const SizedBox(height: 16.0),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên danh mục',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên danh mục';
                }
                return null;
              },
            ),

            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleAddUpdateCategory,
              child: Text(widget.shopCategory != null ? 'Lưu' : 'Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}
