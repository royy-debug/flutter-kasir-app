import 'package:flutter/material.dart';

class RoundedSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const RoundedSearchField({
    super.key,
    required this.controller,
    required this.hint,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
