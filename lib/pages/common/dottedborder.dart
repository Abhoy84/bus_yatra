import 'package:flutter/material.dart';

void main() {
  runApp(DottedBorderLeftApp());
}

class DottedBorderLeftApp extends StatelessWidget {
  const DottedBorderLeftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DottedBorderLeftScreen(),
    );
  }
}

class DottedBorderLeftScreen extends StatelessWidget {
  const DottedBorderLeftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dotted Border Left Container'),
      ),
      body: Center(
        child: DottedBorderLeftContainer(),
      ),
    );
  }
}

class DottedBorderLeftContainer extends StatelessWidget {
  const DottedBorderLeftContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: CustomPaint(
        painter: DottedBorderPainter(),
        child: const Center(
          child: Text(
            'Dotted Border',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 12;
    const dashSpace = 9;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
