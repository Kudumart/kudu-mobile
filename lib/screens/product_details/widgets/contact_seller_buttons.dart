part of '../screen.dart';

class _ContactSellerButtons extends StatelessWidget {
  final String? sellerPhoneNumber;
  const _ContactSellerButtons({this.sellerPhoneNumber});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Message Seller Button
        Flexible(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () {
              if (isLoggedIn) {
                const MessagesScreenRoute().go(context);
              } else {
                const SignUpOptionsScreenRoute(UserType.customer).push(context);
              }
            },
            icon: SvgPicture.asset(AppUiIcon.chat,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    AppUiColor.primary, BlendMode.srcIn)),
            label: const Text(
              'Message Seller',
              style: TextStyle(
                  color: AppUiColor.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppUiColor.primary),
              maximumSize: const Size(double.infinity, 47),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),

        const SizedBox(width: 5),

        // Call Button
        Flexible(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              if (isLoggedIn) {
                callNumber(context, "+15433465837");
              } else {
                const SignUpOptionsScreenRoute(UserType.customer).push(context);
              }
            },
            icon: SvgPicture.asset(AppUiIcon.phone,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            label: const Text(
              'Call',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppUiColor.primary,
              maximumSize: const Size(double.infinity, 47),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
