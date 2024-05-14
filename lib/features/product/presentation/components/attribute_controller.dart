import 'dart:developer';

import '../../domain/entities/dto/product_attribute_request.dart';
import '../../domain/entities/dto/product_variant_request.dart';

class AttributeController {
  //extends ChangeNotifier
  AttributeController(
    // this.type,
    // this.recentAttribute,
    // List<String> attributes,
    this.attributeGroups,
  );

  factory AttributeController.initFromVariants(List<ProductVariantRequest> variants) {
    final Map<String, List<String>> attributeGroups = {};
    for (final variant in variants) {
      for (final attribute in variant.productAttributeRequests) {
        // check if the attribute group is already in the list
        if (attributeGroups.containsKey(attribute.name)) {
          // check if the attribute value is already in the list >> if not, add it
          if (!attributeGroups[attribute.name]!.contains(attribute.value)) {
            attributeGroups[attribute.name]!.add(attribute.value);
          }
        } else {
          attributeGroups[attribute.name] = [attribute.value];
        }
      }
    }
    return AttributeController(attributeGroups);
  }
  // the first key is the attribute group name. eg. "Color", "Size"
  // the second key is the attribute value. eg. {"Color": ["Red", "Blue"], "Size": ["XL", "L"]}
  Map<String, List<String>> attributeGroups;

  void addGroupAttribute(Map<String, List<String>> newData) {
    log('addAttribute: $newData');
    attributeGroups.addAll(newData);
    // notifyListeners(); //? need to notify listeners?
  }

  void removeAttributeAt(String attributeGroup, String attributeValue) {
    attributeGroups[attributeGroup]?.remove(attributeValue);
    // check if the attribute group is empty, remove it
    if (attributeGroups[attributeGroup]!.isEmpty) {
      attributeGroups.remove(attributeGroup);
    }
    // notifyListeners(); //? need to notify listeners?
  }

  void clear() {
    attributeGroups.clear();
    // notifyListeners(); //? need to notify listeners?
  }

  int get totalGroupCount => attributeGroups.length;
  int get totalVariantCount {
    int count = 1;
    attributeGroups.forEach((key, value) {
      count *= value.length;
    });
    return count;
  }

  // e.g: {"Color": {"Color": "Red", "Color": "Blue"}, "Size": {"Size": "XL", "Size": "L"}}
  // => [["Color": "Red", "Size": "XL"], ["Color": "Red", "Size": "L"], ["Color": "Blue", "Size": "XL"], ["Color": "Blue", "Size": "L"]]
  //! the list maybe larger than example

  // single variant has List<ProductAttributeRequest> attributes
  //> all variants has List<List<ProductAttributeRequest>> attributes
  List<List<ProductAttributeRequest>> get allVariantAttributes {
    final List<List<ProductAttributeRequest>> allVariants = [];

    final int totalGroup = totalGroupCount;
    final int totalVariant = totalVariantCount;

    if (totalGroup == 1) {
      for (int i = 0; i < totalVariant; i++) {
        final List<ProductAttributeRequest> variant = [];
        variant.add(ProductAttributeRequest(
          name: attributeGroups.keys.elementAt(0),
          value: attributeGroups.values.elementAt(0)[i],
        ));
        allVariants.add(variant);
      }
    } else if (totalGroup == 2) {
      for (int i = 0; i < attributeGroups.values.elementAt(0).length; i++) {
        for (int j = 0; j < attributeGroups.values.elementAt(1).length; j++) {
          final List<ProductAttributeRequest> variant = [];
          variant.add(ProductAttributeRequest(
            name: attributeGroups.keys.elementAt(0),
            value: attributeGroups.values.elementAt(0)[i],
          ));
          variant.add(ProductAttributeRequest(
            name: attributeGroups.keys.elementAt(1),
            value: attributeGroups.values.elementAt(1)[j],
          ));
          allVariants.add(variant);
        }
      }
    } else if (totalGroup == 3) {
      for (int i = 0; i < attributeGroups.values.elementAt(0).length; i++) {
        for (int j = 0; j < attributeGroups.values.elementAt(1).length; j++) {
          for (int k = 0; k < attributeGroups.values.elementAt(2).length; k++) {
            final List<ProductAttributeRequest> variant = [];
            variant.add(ProductAttributeRequest(
              name: attributeGroups.keys.elementAt(0),
              value: attributeGroups.values.elementAt(0)[i],
            ));
            variant.add(ProductAttributeRequest(
              name: attributeGroups.keys.elementAt(1),
              value: attributeGroups.values.elementAt(1)[j],
            ));
            variant.add(ProductAttributeRequest(
              name: attributeGroups.keys.elementAt(2),
              value: attributeGroups.values.elementAt(2)[k],
            ));
            allVariants.add(variant);
          }
        }
      }
    }

    return allVariants;
  }
}
