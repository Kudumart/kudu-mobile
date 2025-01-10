part of '../screen.dart';

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 55,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.pen, color: Colors.white, size: 16),
          SizedBox(width: 5),
          Text(
            "Edit",
            style: TextStyle(
                fontSize: 13, color: Colors.white, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
