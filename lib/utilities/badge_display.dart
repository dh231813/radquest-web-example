import 'package:flutter/material.dart';

class BadgeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/objects/BadgePatient.png',
          width: 100, // Set the desired width
          height: 100, // Set the desired height
        ),
        SizedBox(height: 8), // Add some spacing between the image and text
        Text(
          'Badge für herausragende Beratung',
          style: TextStyle(
            fontSize: 16, // Set the desired font size
            fontWeight: FontWeight.bold, // Set the desired font weight
          ),
        ),
      ],
    );
  }
}
