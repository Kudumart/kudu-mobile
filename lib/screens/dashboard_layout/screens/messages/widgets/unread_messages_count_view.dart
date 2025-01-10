part of '../screen.dart';

class _UnreadMessagesCountView extends StatelessWidget {
  final int unread;
  const _UnreadMessagesCountView(this.unread);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 244, 111, 54), shape: BoxShape.circle),
      child: Text(
        unread > 9 ? "9+" : "$unread",
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
