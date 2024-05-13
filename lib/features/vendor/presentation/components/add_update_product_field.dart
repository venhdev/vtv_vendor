import 'package:flutter/material.dart';

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
