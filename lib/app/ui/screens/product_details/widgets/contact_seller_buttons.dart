part of '../screen.dart';

class _ContactSellerButtons extends StatelessWidget {
  final String? sellerPhoneNumber;
  const _ContactSellerButtons({this.sellerPhoneNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Message Seller Button
        Flexible(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: SvgPicture.asset(UiIcon.chat,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(UiColor.primary, BlendMode.srcIn)),
            label: const Text(
              'Message Seller',
              style: TextStyle(
                  color: UiColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: UiColor.primary),
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
            onPressed: () {},
            icon: SvgPicture.asset(UiIcon.phone,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            label: const Text(
              'Call',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: UiColor.primary,
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
