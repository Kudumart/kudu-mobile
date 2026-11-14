import 'package:flutter/material.dart';
import 'package:kudu/models/enums_and_extensions.dart';

class ProductConditionBanner extends StatelessWidget {
  final ProductCondition status;
  const ProductConditionBanner(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final isBrandNew = status == ProductCondition.brandNew;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isBrandNew
            ? const Color(0xFFDCFCE7).withValues(alpha: 0.95)
            : const Color(0xFFFEE2E2).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isBrandNew
              ? const Color(0xFF86EFAC).withValues(alpha: 0.85)
              : const Color(0xFFFECACA).withValues(alpha: 0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        status.printableName(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isBrandNew ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
        ),
      ),
    );
  }
}
