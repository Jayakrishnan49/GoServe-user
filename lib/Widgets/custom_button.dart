

import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final String text;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? textColor;
  final Icon? icon;
  final Color? borderColor;

  const CustomButton({
    super.key,
    this.onTap,
    this.color,
    required this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.textColor,
    this.icon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 60,
      width: width ?? 200,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            color ?? AppColors.buttonColor,
          ),
          foregroundColor: WidgetStateProperty.all(
            textColor ?? Colors.white,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 50),
              side: BorderSide(color: borderColor ?? AppColors.buttonColor),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}