part of '../screen.dart';

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      width: 72,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.pen, color: Colors.black, size: 16),
          SizedBox(width: 5),
          Text(
            "Edit",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
