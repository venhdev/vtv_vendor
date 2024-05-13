import 'package:flutter/material.dart';

class AddUpdateAttributeDialog extends StatefulWidget {
  const AddUpdateAttributeDialog({
    super.key,
    this.initValue,
  });

  final Map<String, List<String>>? initValue; //? init value for editing

  @override
  State<AddUpdateAttributeDialog> createState() => _AddUpdateAttributeDialogState();
}

class _AddUpdateAttributeDialogState extends State<AddUpdateAttributeDialog> {
  final _formKey = GlobalKey<FormState>();
  late String groupName;
  late List<String> attributes;

  @override
  void initState() {
    super.initState();
    if (widget.initValue != null) {
      groupName = widget.initValue!.keys.first;
      attributes = widget.initValue!.values.first;
    } else {
      groupName = '';
      attributes = [''];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Thêm thuộc tính mới'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Nhóm thuộc tính'),
              onChanged: (value) {
                // _attributeGroups[value] = [];
                groupName = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nhóm không được để trống';
                }
                return null;
              },
            ),
            //# attribute list (can edit)
            for (var i = 0; i < attributes.length; i++)
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: TextFormField(
                  decoration: const InputDecoration(hintText: 'Thuộc tính'),
                  onChanged: (value) {
                    attributes[i] = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Không được để trống';
                    }
                    return null;
                  },
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      attributes.removeAt(i);
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),

            //# btn to add more attribute line
            TextButton.icon(
              onPressed: () {
                setState(() {
                  attributes.add('');
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm thuộc tính'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: attributes.isEmpty
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop({groupName: attributes});
                  }
                },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
