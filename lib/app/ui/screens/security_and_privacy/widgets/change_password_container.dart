part of '../screen.dart';

class _ChangePasswordContainer extends StatelessWidget {
  const _ChangePasswordContainer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => const ChangePasswordScreenRoute().push(context),
      child: Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(20, 14, 14, 14),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD2D2D2)),
            borderRadius: BorderRadius.circular(9),
            color: AppUiColor.grey50),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Change Password",
                style: TextStyle(color: Color(0xFF333333), fontSize: 14)),
            Icon(
              CupertinoIcons.chevron_forward,
              size: 18,
              color: Color(0xFFA4A4A4),
            )
          ],
        ),
      ),
    );
  }
}
