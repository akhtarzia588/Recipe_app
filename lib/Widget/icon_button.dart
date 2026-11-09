import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback Pressed;

  const MyIconButton({super.key, required this.icon, required this.Pressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        fixedSize: const Size(43, 43),
        backgroundColor: Colors.white,
      ),

      icon: Icon(icon),
      onPressed: Pressed,
    );
  }
}
