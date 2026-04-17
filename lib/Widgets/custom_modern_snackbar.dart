import 'package:flutter/material.dart';
import 'package:project_2/Constants/app_color.dart';

enum SnackBarType { success, error, warning, info }

class ModernSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    String? title,
    Duration duration = const Duration(seconds: 3),
    IconData? customIcon,
    Color? customColor,
    VoidCallback? onTap,
  }) {
    final config = _getSnackBarConfig(type);
    final icon = customIcon ?? config['icon'] as IconData;
    final backgroundColor = customColor ?? config['color'] as Color;
    final textColor = _getContrastColor(backgroundColor);

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ModernSnackBarWidget(
        message: message,
        title: title,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        duration: duration,
        onDismiss: () => overlayEntry.remove(),
        onTap: onTap,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  static Map<String, dynamic> _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return {
          'icon': Icons.check_circle_rounded,
          'color': AppColors.successAlert,
        };
      case SnackBarType.error:
        return {
          'icon': Icons.error_rounded,
          'color': AppColors.rejected,
        };
      case SnackBarType.warning:
        return {
          'icon': Icons.warning_rounded,
          'color': AppColors.buttonColor,
        };
      case SnackBarType.info:
        return {
          'icon': Icons.info_rounded,
          'color': AppColors.info,
        };
    }
  }

  static Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppColors.textColor : AppColors.secondary;
  }
}

class _ModernSnackBarWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const _ModernSnackBarWidget({
    required this.message,
    this.title,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
    required this.onDismiss,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Auto dismiss after duration
    // Future.delayed(duration, () {
    //   onDismiss();
    // });

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: onTap,
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx.abs() > 500) {
                onDismiss();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                    spreadRadius: -8,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Subtle gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Icon container
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: textColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (title != null) ...[
                              Text(
                                title!,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                            Text(
                              message,
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Close button
                      GestureDetector(
                        onTap: onDismiss,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: textColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: textColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}