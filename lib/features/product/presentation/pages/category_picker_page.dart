import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/category_with_nested_children_entity.dart';
import '../../domain/repository/vendor_product_repository.dart';

class CategoryPickerPage extends StatefulWidget {
  const CategoryPickerPage({super.key});

  @override
  State<CategoryPickerPage> createState() => _CategoryPickerPageState();
}

class _CategoryPickerPageState extends State<CategoryPickerPage> {
  // bool _isLoading = false;
  // void showLoading() => {if (mounted) setState(() => _isLoading = true)};
  // void hideLoading() => {if (mounted) setState(() => _isLoading = false)};

  final List<CategoryWithNestedChildrenEntity> _categories = [];

  void loadData() {
    sl<VendorProductRepository>().getCategoryWithNestedChildren().then((resp) {
      resp.fold(
        (error) => MessageScreen.error(error.message),
        (ok) {
          setState(() {
            _categories.clear();
            _categories.addAll(ok.data!);
          });
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn danh mục sản phẩm'),
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) => NestedCategoryList(
          category: _categories[index],
          onSelected: (category) {
            Navigator.of(context).pop(category);
          },
        ),
      ),
    );
  }
}

class NestedCategoryList extends StatefulWidget {
  const NestedCategoryList({super.key, required this.category, required this.onSelected});

  final CategoryWithNestedChildrenEntity category;
  final ValueChanged<CategoryWithNestedChildrenEntity> onSelected;

  @override
  State<NestedCategoryList> createState() => _NestedCategoryListState();
}

class _NestedCategoryListState extends State<NestedCategoryList> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.category.parent.name),
          onTap: () {
            if (widget.category.children.isEmpty) {
              widget.onSelected(widget.category);
            } else {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
          },
          trailing: widget.category.children.isNotEmpty
              ? Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down)
              : const Icon(Icons.arrow_forward),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.category.children.length,
              itemBuilder: (context, index) => NestedCategoryList(
                category: widget.category.children[index],
                onSelected: widget.onSelected,
              ),
            ),
          ),
      ],
    );
  }
}
