import 'package:flutter/material.dart';

class BottomNaviWidget extends StatelessWidget {
  const BottomNaviWidget({
    super.key,
    this.onTap,
    this.icon,
    required this.selected,
  });
  final void Function()? onTap;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 36,
        width: 36,
        child: Icon(
          icon,
          color: selected ? Colors.orange : Colors.white,
        ),
      ),
    );
  }
}
