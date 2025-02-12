import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String title;
  final TextStyle style;

  const CustomTextWidget({
    super.key,
    required this.title,
    TextStyle? style,
  }) : style = style ??
            const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            );

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style,
    );
  }
}
