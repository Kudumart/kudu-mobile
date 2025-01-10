part of '../screen.dart';

class _NotificationDataCard extends StatelessWidget {
  final NotificationData data;
  const _NotificationDataCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: 23.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data.isRead
                    ? Colors.black12
                    : AppUiColor.primary.withOpacity(0.08)),
            child: SvgPicture.asset(AppUiIcon.bell,
                colorFilter: ColorFilter.mode(
                    data.isRead ? AppUiColor.iconBlack : AppUiColor.primary,
                    BlendMode.srcIn),
                height: 24,
                width: 24,
                fit: BoxFit.contain),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 7),
                Expanded(
                  child: Text(data.content,
                      maxLines: 3, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8),
                Text(
                  formatDate(data.created, [dd, " ", MM, ", ", yyyy]),
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF939393)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
