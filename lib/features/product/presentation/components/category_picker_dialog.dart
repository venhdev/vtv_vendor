// // ignore_for_file: prefer_const_constructors
//TODO delete this file
// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:vtv_common/core.dart';
// import 'package:vtv_common/home.dart';

// import '../../../../service_locator.dart';
// import '../../domain/entities/category_with_nested_children_entity.dart';
// import '../../domain/repository/vendor_product_repository.dart';

// class CategoryPickerDialog extends StatefulWidget {
//   const CategoryPickerDialog({super.key});

//   @override
//   State<CategoryPickerDialog> createState() => _CategoryPickerDialogState();
// }

// class _CategoryPickerDialogState extends State<CategoryPickerDialog> {
//   final _debouncer = FunctionUtils.createDebouncer(milliseconds: 500);
//   final _searchController = TextEditingController();
//   final List<CategoryWithNestedChildrenEntity> _categoriesWithChildren = [];
//   final List<CategoryWithNestedChildrenEntity> _matchedCategoriesWithChildren = []; // matched with search text
//   bool _loading = false;

//   Future<void> _loadData() async {
//     if (mounted) {
//       setState(() {
//         _loading = true;
//       });
//     }

//     final respEither = await sl<VendorProductRepository>().getCategoryWithNestedChildren();

//     respEither.fold(
//       (error) => null,
//       (ok) {
//         if (mounted) {
//           setState(() {
//             _categoriesWithChildren.clear();
//             _categoriesWithChildren.addAll(ok.data!);
//             _loading = false;
//           });
//         }
//       },
//     );
//   }

//   void _search() {
//     final searchText = _searchController.text;
//     if (searchText.isEmpty) {
//       setState(() {
//         _matchedCategoriesWithChildren.clear();
//         return;
//       });
//     }
//     final filteredList = <CategoryWithNestedChildrenEntity>[];
    
//     for (final categoryWithChildren in _categoriesWithChildren) {
//       //> if category has no children, check if parent name contains search text
//       if (categoryWithChildren.children.isEmpty &&
//           categoryWithChildren.parent.name.toLowerCase().contains(searchText.toLowerCase())) {
//         filteredList.add(categoryWithChildren);
//       } else {
//         //> if category has children, check if any child name contains search text
//         final matchedChildren = <CategoryEntity>[];
//         for (final child in categoryWithChildren.children) {
//           if (child.name.toLowerCase().contains(searchText.toLowerCase())) {
//             matchedChildren.add(child);
//           }
//         }
//         //? if any child matched, add parent category to the list
//         if (matchedChildren.isNotEmpty) {
//           filteredList.add(
//             CategoryWithNestedChildrenEntity(
//               parent: categoryWithChildren.parent,
//               children: matchedChildren,
//             ),
//           );
//         }
//       }
//     }

//     if (mounted) {
//       setState(() {
//         _matchedCategoriesWithChildren.clear();
//         _matchedCategoriesWithChildren.addAll(filteredList);
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text(
//               'Danh mục sản phẩm',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Divider(),
//             TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 _debouncer.run(() {
//                   log('searching... $value');
//                   _search();
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: 'Tìm kiếm danh mục',
//                 prefixIcon: Icon(Icons.search),
//                 suffixIcon: _searchController.text.isNotEmpty
//                     ? IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _searchController.clear();
//                             _matchedCategoriesWithChildren.clear();
//                           });
//                         },
//                         icon: Icon(Icons.close),
//                       )
//                     : null,
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: Builder(
//                 builder: (context) {
//                   if (_categoriesWithChildren.isNotEmpty && !_loading) {
//                     //# if no search text, show all categories
//                     if (_searchController.text.isEmpty) {
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: _categoriesWithChildren.length,
//                         itemBuilder: (context, index) {
//                           final category = _categoriesWithChildren[index];
//                           return CategoryWithNestedChildren(category: category);
//                         },
//                       );
//                     } else {
//                       //# if search text, show matched categories
//                       if (_matchedCategoriesWithChildren.isEmpty) {
//                         return const Center(
//                           child: Text('Không tìm thấy danh mục phù hợp'),
//                         );
//                       }
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: _matchedCategoriesWithChildren.length,
//                         itemBuilder: (context, index) {
//                           final category = _matchedCategoriesWithChildren[index];
//                           return CategoryWithNestedChildren(category: category);
//                         },
//                       );
//                     }
//                   } else {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               ),
//             ),
//             // close dialog button
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Đóng'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CategoryWithNestedChildren extends StatelessWidget {
//   const CategoryWithNestedChildren({
//     super.key,
//     required this.category,
//   });

//   final CategoryWithNestedChildrenEntity category;

//   @override
//   Widget build(BuildContext context) {
//     return Ink(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade300),
//         ),
//         color: Colors.grey.shade100,
//       ),
//       child: Column(
//         children: [
//           if (category.children.isEmpty)
//             ListTile(
//               title: Text(category.parent.name),
//               subtitle: Text(category.parent.description),
//               onTap: () {
//                 Navigator.of(context).pop(category.parent);
//               },
//             )
//           else ...[
//             Text(category.parent.name, style: TextStyle(fontWeight: FontWeight.bold)),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: category.children.length,
//               itemBuilder: (context, index) {
//                 final child = category.children[index];
//                 return ListTile(
//                   title: Text(child.name),
//                   subtitle: Text(child.description),
//                   onTap: () {
//                     Navigator.of(context).pop(child);
//                   },
//                 );
//               },
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
