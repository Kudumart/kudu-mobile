part of '../screen.dart';

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Container(
                height: 1,
                color: const Color(0xFFE5E5E5),
              )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "or",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          Flexible(
              flex: 1,
              child: Container(
                height: 1,
                color: const Color(0xFFE5E5E5),
              )),
        ],
      ),
    );
  }
}
