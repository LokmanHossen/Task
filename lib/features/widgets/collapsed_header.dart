import 'package:flutter/material.dart';

class CollapsedHeader extends StatelessWidget {
  final Function(String) onSearch;

  const CollapsedHeader({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_outline_outlined, color: Colors.blue),
        ),
        Expanded(
          child: Container(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.5),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
