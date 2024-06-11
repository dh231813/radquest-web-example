// jenny_dialog.dart

import 'package:flutter/material.dart';

class GameDialog extends StatelessWidget {
  final List<DialogText> dialogText;
  final VoidCallback onFinish;

  const GameDialog({required this.dialogText, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: dialogText.map((text) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 266,
                    child: text.image,
                  ),
                  SizedBox(width: 16), // Increase spacing for larger image
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: text.richText,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DialogText {
  final List<TextSpan> richText;
  final Image image;

  DialogText({
    required this.richText,
    required this.image,
  });
}
