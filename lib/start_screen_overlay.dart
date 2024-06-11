import 'dart:async';
import 'package:flutter/material.dart';

class StartScreenOverlay extends StatelessWidget {
  final VoidCallback onStartGame;

  const StartScreenOverlay({Key? key, required this.onStartGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54, // 50% opacity background
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/objects/pixellogolarge.png', // Path to the RadQuest logo
              width: 800,
              height: 328,
            ),
            const SizedBox(height: 20),
            const Text(
              'Desktop: Drücke die Leertaste, um mit den Menschen im Krankenhaus zu sprechen',
              style: TextStyle(
                fontFamily: 'VT323', // Using the minecraft font
                fontSize: 28,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Smartphone: Tippe auf Menschen für Interaktionen',
              style: TextStyle(
                fontFamily: 'VT323', // Using the minecraft font
                fontSize: 28,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onStartGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0d2226), // Background color for the button
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                'Spiel starten',
                style: TextStyle(
                  fontFamily: 'VT323', // Using the minecraft font
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
