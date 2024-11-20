part of '../screen.dart';

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      child: TextField(
        decoration: InputDecoration(
          constraints: const BoxConstraints(minHeight: 46, maxHeight: 47),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          hintText: 'Enter search keyword',
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
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppUiColor.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppUiColor.borderline),
          ),
        ),
      ),
    );
  }
}
