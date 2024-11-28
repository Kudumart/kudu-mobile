part of '../screen.dart';

class _SearchBarWithFilter extends StatelessWidget
    implements PreferredSizeWidget {
  const _SearchBarWithFilter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _SearchBar()),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _openSearchFilterBottomSheet(context),
          child: Container(
            height: 47,
            width: 45,
            padding: const EdgeInsets.all(12.5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppUiColor.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SvgPicture.asset(
              AppUiIcon.filter,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);

  _openSearchFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // To ensure content is visible with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6, // Initial height (60% of screen)
            maxChildSize: 0.9, // Maximum height (90% of screen)
            minChildSize: 0.3, // Minimum height (30% of screen)
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(),
              );
            },
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 46, maxHeight: 47),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        hintText: 'Search products, brands, etc...',
        hintStyle: const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            AppUiIcon.search,
            height: 21,
            width: 21,
            fit: BoxFit.contain,
            colorFilter:
                const ColorFilter.mode(AppUiColor.iconBlack, BlendMode.srcIn),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, 16.0, 16, 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppUiColor.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppUiColor.borderline),
        ),
      ),
    );
  }
}
