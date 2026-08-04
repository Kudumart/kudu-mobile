part of '../screen.dart';

class _ReviewsSection extends StatelessWidget {
  final List<ReviewData> reviews;
  const _ReviewsSection({required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reviews (${reviews.length})",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppUiColor.iconBlack,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, index) {
            var review = reviews[index];
            var reviewerName = "${review.user?.firstName ?? ""} ${review.user?.lastName ?? ""}".trim();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppImage(
                  imgUrl: "",
                  fit: BoxFit.cover,
                  borderColor: Colors.grey,
                  radius: 360,
                  height: 35,
                  width: 35,
                  usePlaceHolder: true,
                  useTextPlaceholder: true,
                  placeHolderColor: Colors.white,
                  contactName: reviewerName.isEmpty ? "?" : reviewerName,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        reviewerName.isEmpty ? "Anonymous" : reviewerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            Icons.star,
                            color: i + 1 <= (review.rating ?? 0)
                                ? const Color(0xFFFBBC05)
                                : const Color(0xFFD1D1D1),
                            size: 14,
                          );
                        }),
                      ),
                      if ((review.comment ?? "").trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          review.comment ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppUiColor.iconBlack,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
