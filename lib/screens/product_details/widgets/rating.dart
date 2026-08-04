part of '../screen.dart';

class _Rating extends StatelessWidget {
  final double value;
  final int totalReviews;
  const _Rating(this.value, {this.totalReviews = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              color: index + 1 <= value
                  ? const Color(0xFFFBBC05)
                  : const Color(0xFFD1D1D1),
              size: 16,
            );
          }),
        ),
        const SizedBox(width: 4),
        Text(
          totalReviews > 0
              ? '$value ($totalReviews review${totalReviews == 1 ? "" : "s"})'
              : 'No reviews yet',
          style: const TextStyle(
            color: AppUiColor.textBlue,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
