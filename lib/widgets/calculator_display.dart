import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String display;
  final String expression;

  const CalculatorDisplay({
    super.key,
    required this.display,
    required this.expression,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (expression.isNotEmpty && expression != display)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                expression,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 60),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                display,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  color: theme.colorScheme.onSurface,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
