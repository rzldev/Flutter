import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final Text text;
  final Gradient gradient;

  GradientText({
    @required this.text,
    @required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return gradient
            .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: text,
    );
  }
}
