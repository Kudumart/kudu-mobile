part of '../screen.dart';

class _AppBarTitle extends StatelessWidget {
  final String counterpartName;
  final String productName;
  final String? counterpartAvatarUrl;
  const _AppBarTitle(
      {required this.counterpartName,
      this.counterpartAvatarUrl,
      required this.productName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserCircleAvatar(counterpartAvatarUrl ?? "",
            circleRadius: 20, imageSize: const Size(40, 40)),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            const SizedBox(height: 5),
            Text(
              counterpartName,
              maxLines: 1,
              style: const TextStyle(fontSize: 12, color: AppUiColor.iconBlack),
            ),
          ],
        )),
      ],
    );
  }
}
