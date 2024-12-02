part of '../screen.dart';

class _DoBView extends StatelessWidget {
  final String? date;
  const _DoBView(this.date);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 48,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date ?? "Date of Birth",
                style:
                    const TextStyle(fontSize: 13, color: AppUiColor.primary)),
            const Icon(
              CupertinoIcons.calendar,
              color: Colors.black,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
