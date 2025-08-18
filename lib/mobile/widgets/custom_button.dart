import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool expanded;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final btn = ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}