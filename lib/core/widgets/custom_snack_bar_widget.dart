import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    Color backgroundColor = Colors.grey,
    IconData icon = Icons.info_outline,
    super.duration = const Duration(milliseconds: 800),
  }) : super(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.fixed,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor.withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(8),

              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withValues(alpha: 0.8),
              //     blurRadius: 10,
              //     // Обратите внимание: Offset(100, 100) задаёт сильное смещение тени,
              //     // возможно, стоит уменьшить это значение для более естественного вида.
              //     offset: const Offset(0, 4),
              //   ),
              // ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
}
