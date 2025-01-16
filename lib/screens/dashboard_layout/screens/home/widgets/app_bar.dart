part of '../screen.dart';

class _AppBar extends StatelessWidget {
  final HomeViewModel provider;

  const _AppBar({
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      height: 52,
      child: Row(
        children: [
          provider.photo != null
              ? UserCircleAvatar(
                  provider.photo,
                  circleRadius: 20,
                  imageSize: const Size(40, 40),
                )
              : Image.asset(AppUiImage.userAvatar, height: 50, width: 50),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back,",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8C8A93),
                ),
              ),
              Row(
                children: [
                  Text(provider.firstName != null ? _formatUserName() : "Guest",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: provider.isVerified == true
                            ? const Color.fromARGB(255, 9, 121, 42)
                            : const Color.fromARGB(255, 243, 99, 51),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      provider.isVerified == true
                          ? "Verified"
                          : " • Unverified",
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () => const NotificationsScreenRoute().push(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppUiColor.primary.withOpacity(0.08)),
              child: SvgPicture.asset(AppUiIcon.bellFilled,
                  height: 24, width: 24, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _openDrawer(context),
            child: const Icon(
              Icons.menu,
              size: 26,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  _openDrawer(BuildContext context) {
    if (!Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).openDrawer();
    }
  }

  String _formatUserName() {
    final nameParts = provider.firstName!.split(' ');
    if (nameParts.length > 1) {
      // If the name has multiple parts (e.g., first and last name)
      for (final part in nameParts) {
        if (part.length <= 8) {
          return part;
        }
      }
    }

    if (provider.firstName!.length <= 8) {
      return provider.firstName!;
    }

    // If the name is a single part or all parts are longer than 8 characters
    return "${provider.firstName!.substring(0, 8)}.";
  }
}
