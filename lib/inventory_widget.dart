import 'package:flutter/material.dart';

class InventoryWidget extends StatelessWidget {
  final List<String> itemImages;

  InventoryWidget({required this.itemImages});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 10,
      child: Column(
        children: itemImages.map((imagePath) {
          return Image.asset(
            imagePath,
            width: 50,
            height: 50,
          );
        }).toList(),
      ),
    );
  }
}
