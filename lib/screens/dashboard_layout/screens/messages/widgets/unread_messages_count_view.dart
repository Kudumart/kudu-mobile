part of '../screen.dart';

class _UnreadMessagesCountView extends StatelessWidget {
  final int unread;
  const _UnreadMessagesCountView(this.unread);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppUiColor.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        unread > 9 ? "9+" : "$unread",
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
