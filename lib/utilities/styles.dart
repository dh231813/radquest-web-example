import 'package:flutter/material.dart';

// Define a global TextStyle for dialogs with reduced line height
const TextStyle dialogTextStyle = TextStyle(
  fontFamily: 'VT323', // Using the VT323 font
  fontSize: 24,
  color: Colors.white,
  height: 1.0, // Adjust this value to reduce line spacing
);

// Define a global TextStyle for highlighted text in light blue and bold
const TextStyle highlightTextStyle = TextStyle(
  fontFamily: 'VT323', // Using the VT323 font
  fontSize: 24,
  color: Color(0xFF1fbfa2), // Light blue color
  fontWeight: FontWeight.bold,
  height: 1.0, // Adjust this value to match dialogTextStyle
);
