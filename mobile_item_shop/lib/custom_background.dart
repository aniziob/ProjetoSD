import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground(
      {Key? key, required this.child, required this.w, required this.h})
      : super(key: key);

  final Widget child;
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF273A48),
      ),
      child: Stack(
        children: <Widget>[
          CustomPaint(
            painter: MyPainter(),
            size: Size(w, h),
          ),
          child,
        ],
      ),
    );
  }
}

// Usado para personalizar o background do Widget ItemShopPage
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.deepOrangeAccent;
    paint.strokeWidth = 128;

    var p1 = Offset(-64, size.height / 2);
    var p2 = Offset(size.width * (3 / 4), -64);

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // throw UnimplementedError();
    // Sempre retorna falso, porque MyPainter não possui propriedades mutáveis
    return false;
  }
}
