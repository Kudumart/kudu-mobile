part of '../screen.dart';

class _InfoNameAndValue extends StatelessWidget {
  final String infoName;
  final String infoValue;
  final Color? infoValueTextColor;
  const _InfoNameAndValue(
      {required this.infoName,
      this.infoValueTextColor,
      required this.infoValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF4F4F4)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(infoName,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          Text(
            infoValue,
            style: TextStyle(
                fontSize: 13,
                color: infoValueTextColor ?? AppUiColor.iconBlack),
          )
        ],
      ),
    );
  }
}
