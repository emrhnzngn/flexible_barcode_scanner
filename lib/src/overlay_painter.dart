import 'package:flutter/material.dart';

class BarcodeScannerOverlay extends StatefulWidget {
  const BarcodeScannerOverlay({
    super.key,
    this.lineColor,
    this.strokeColor,
  });

  /// The color of the animated scanning line.
  final Color? lineColor;

  /// The color of the border for the scanning area.
  final Color? strokeColor;

  @override
  BarcodeScannerOverlayState createState() => BarcodeScannerOverlayState();
}

class BarcodeScannerOverlayState extends State<BarcodeScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for the scanning line.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Define the vertical movement range of the scanning line.
    _animation = Tween<double>(begin: -50, end: 50).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Stack(
            children: [
              // Scanning area frame.
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: OverlayPainter(strokeColor: widget.strokeColor),
                  ),
                ),
              ),
              // Animated scanning line.
              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: LinePainter(
                        _animation.value,
                        widget.lineColor,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OverlayPainter extends CustomPainter {
  final Color? strokeColor;
  OverlayPainter({this.strokeColor});
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.06250000, size.height);
    path_0.cubicTo(size.width * 0.02798047, size.height, 0,
        size.height * 0.9720195, 0, size.height * 0.9375000);
    path_0.lineTo(0, size.height * 0.7031250);
    path_0.arcToPoint(Offset(size.width * 0.01562500, size.height * 0.7187500),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.01562500, size.height * 0.9375000);
    path_0.cubicTo(
        size.width * 0.01562500,
        size.height * 0.9633867,
        size.width * 0.03661328,
        size.height * 0.9843750,
        size.width * 0.06250000,
        size.height * 0.9843750);
    path_0.lineTo(size.width * 0.2812500, size.height * 0.9843750);
    path_0.arcToPoint(Offset(size.width * 0.2968750, size.height),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.close();
    path_0.moveTo(size.width, size.height * 0.7031250);
    path_0.arcToPoint(Offset(size.width * 0.9843750, size.height * 0.7187500),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.9843750, size.height * 0.9375000);
    path_0.cubicTo(
        size.width * 0.9843750,
        size.height * 0.9633867,
        size.width * 0.9633867,
        size.height * 0.9843750,
        size.width * 0.9375000,
        size.height * 0.9843750);
    path_0.lineTo(size.width * 0.7187500, size.height * 0.9843750);
    path_0.arcToPoint(Offset(size.width * 0.7031250, size.height),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.9375000, size.height);
    path_0.cubicTo(size.width * 0.9720195, size.height, size.width,
        size.height * 0.9720195, size.width, size.height * 0.9375000);
    path_0.close();
    path_0.moveTo(size.width * 0.7031250, 0);
    path_0.arcToPoint(Offset(size.width * 0.7187500, size.height * 0.01562500),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.9375000, size.height * 0.01562500);
    path_0.cubicTo(
        size.width * 0.9633867,
        size.height * 0.01562500,
        size.width * 0.9843750,
        size.height * 0.03661328,
        size.width * 0.9843750,
        size.height * 0.06250000);
    path_0.lineTo(size.width * 0.9843750, size.height * 0.2812500);
    path_0.arcToPoint(Offset(size.width, size.height * 0.2968750),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width, size.height * 0.06250000);
    path_0.cubicTo(size.width, size.height * 0.02798047, size.width * 0.9720195,
        0, size.width * 0.9375000, 0);
    path_0.close();
    path_0.moveTo(0, size.height * 0.2968750);
    path_0.arcToPoint(Offset(size.width * 0.01562500, size.height * 0.2812500),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.01562500, size.height * 0.06250000);
    path_0.cubicTo(
        size.width * 0.01562500,
        size.height * 0.03661328,
        size.width * 0.03661328,
        size.height * 0.01562500,
        size.width * 0.06250000,
        size.height * 0.01562500);
    path_0.lineTo(size.width * 0.2812500, size.height * 0.01562500);
    path_0.arcToPoint(Offset(size.width * 0.2968750, 0),
        radius: Radius.elliptical(
            size.width * 0.01562500, size.height * 0.01562500),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.06250000, 0);
    path_0.cubicTo(size.width * 0.02798047, 0, 0, size.height * 0.02798047, 0,
        size.height * 0.06250000);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = strokeColor ?? Colors.white;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LinePainter extends CustomPainter {
  final double position;
  final Color? lineColor;

  LinePainter(this.position, this.lineColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor ?? Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final startX = size.width / 2 + 120;
    final endX = size.width / 2 - 120;
    final centerY = size.height / 2 + position;
    canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
