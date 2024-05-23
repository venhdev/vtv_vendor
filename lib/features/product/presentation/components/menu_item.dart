import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

class MenuItem extends StatelessWidget {
  const MenuItem(
    this.label,
    this.icon, {
    super.key,
    this.onPressed,
  });
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      label: label,
      leadingIcon: icon,
      fontSize: 12,
      reverseDirection: true,
      onPressed: onPressed,
    );
  }
}
