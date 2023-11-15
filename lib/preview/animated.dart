import 'package:flutter/material.dart';

class AnimatedGradientMesh extends StatefulWidget {
  const AnimatedGradientMesh({super.key});

  @override
  _AnimatedGradientMeshState createState() => _AnimatedGradientMeshState();
}

class _AnimatedGradientMeshState extends State<AnimatedGradientMesh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: CustomPaint(
          painter: _GradientMeshPainter(_controller),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _GradientMeshPainter extends CustomPainter {
  final Animation<double> animation;

  _GradientMeshPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = _buildGradient(rect)
      ..blendMode = BlendMode.overlay;

    final Path path = _buildMeshPath(rect);
    canvas.clipPath(path);
    canvas.drawPath(path, paint);
  }

  Shader _buildGradient(Rect rect) {
    return const LinearGradient(
      colors: [
        Colors.yellow,
        Colors.green,
        Colors.red,
      ],
    ).createShader(rect);
  }

  Path _buildMeshPath(Rect rect) {
    const int rows = 5;
    const int columns = 5;

    final double columnWidth = rect.width / columns;
    final double rowHeight = rect.height / rows;

    final Path path = Path();

    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final double x = column * columnWidth;
        final double y = row * rowHeight;

        path.addRect(Rect.fromLTWH(x, y, columnWidth, rowHeight));
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
