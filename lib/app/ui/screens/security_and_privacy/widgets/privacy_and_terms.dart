part of '../screen.dart';

class _PrivacyAndTermsOfService extends StatelessWidget {
  const _PrivacyAndTermsOfService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 103,
      padding: const EdgeInsets.fromLTRB(20, 14, 14, 14),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD2D2D2)),
          borderRadius: BorderRadius.circular(9),
          color: AppUiColor.grey50),
      child: Column(
        children: [
          const Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Privacy Policy",
                    style: TextStyle(color: Color(0xFF333333), fontSize: 14)),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: Color(0xFFA4A4A4),
                )
              ],
            ),
          ),
          const SizedBox(height: 17),
          Container(height: 1, color: const Color(0xFFD2D2D2)),
          const SizedBox(height: 17),
          const Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Terms of Service",
                    style: TextStyle(color: Color(0xFF333333), fontSize: 14)),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: Color(0xFFA4A4A4),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
