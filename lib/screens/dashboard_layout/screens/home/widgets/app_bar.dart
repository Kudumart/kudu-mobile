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
      height: 76,
      child: Row(
        children: [
          provider.photo != null
              ? UserCircleAvatar(
                  provider.photo,
                  circleRadius: 20,
                  imageSize: const Size(40, 40),
                )
              : Image.asset(AppUiImage.userAvatar, height: 50, width: 50),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome back,",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8C8A93),
                  ),
                ),
                Text(provider.firstName != null ? _formatUserName() : "Guest",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                if (provider.accountType?.toLowerCase() == 'vendor') ...[
                  const SizedBox(height: 3),
                  _KycStatusBadge(
                    status: provider.kycStatus,
                    onTap: () => const ProfileScreenRoute().go(context),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const CountrySelectDropdown(),
          const SizedBox(width: 8),
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

class _KycStatusBadge extends StatelessWidget {
  final String? status;
  final VoidCallback onTap;

  const _KycStatusBadge({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final normalized = status?.toLowerCase();
    late final String label;
    late final Color foreground;
    late final Color background;
    late final IconData icon;

    switch (normalized) {
      case 'approved':
      case 'verified':
        label = 'Verified';
        foreground = const Color(0xFF067647);
        background = const Color(0xFFECFDF3);
        icon = Icons.verified_outlined;
        break;
      case 'pending':
      case 'under_review':
        label = 'Under Review';
        foreground = const Color(0xFFB54708);
        background = const Color(0xFFFFFAEB);
        icon = Icons.schedule_outlined;
        break;
      case 'rejected':
      case 'changes_requested':
        label = 'Changes Requested';
        foreground = const Color(0xFFB42318);
        background = const Color(0xFFFEF3F2);
        icon = Icons.error_outline;
        break;
      default:
        label = 'Unverified';
        foreground = const Color(0xFFC4320A);
        background = const Color(0xFFFFF4ED);
        icon = Icons.shield_outlined;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 145),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: foreground.withValues(alpha: .22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: foreground),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.chevron_right, size: 13, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
