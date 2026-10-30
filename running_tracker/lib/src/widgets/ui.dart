import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Toast flotante: verde si salió bien, rojo si hubo error
void showToast(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Icon(
              error ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
}

// Botón que se bloquea y muestra un spinner mientras carga
Widget loadingButton({
  required String text,
  required bool loading,
  required VoidCallback onPressed,
}) {
  return FilledButton(
    onPressed: loading ? null : onPressed,
    style: FilledButton.styleFrom(
      disabledBackgroundColor: AppTheme.primaryColor.withValues(alpha: 0.5),
    ),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(text),
    ),
  );
}

// Animación de entrada: aparece de abajo hacia arriba
Widget appearAnimation(Widget child) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeOut,
    builder: (context, value, child) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 40 * (1 - value)),
        child: child,
      ),
    ),
    child: child,
  );
}
