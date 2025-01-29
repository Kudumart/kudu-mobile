part of '../screen.dart';

class _BlackContainer extends StatelessWidget {
  const _BlackContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 25, 18, 30),
      height: 99,
      color: Colors.black,
      child: Row(
        children: [
          Flexible(
              child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppUiColor.primary,
                borderRadius: BorderRadius.circular(7)),
            child: const Text(
              "Auction your Product",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          )),
          const SizedBox(width: 12),
          Flexible(
              child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xFF202020),
                borderRadius: BorderRadius.circular(7)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppUiIcon.monitor,
                    height: 15, width: 15, fit: BoxFit.contain),
                const SizedBox(width: 6),
                const Text(
                  "Monitor",
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD1D1D1),
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
