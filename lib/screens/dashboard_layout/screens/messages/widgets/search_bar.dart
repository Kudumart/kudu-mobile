part of '../screen.dart';

class _SearchBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String)? onSearch;
  const _SearchBar({this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: TextField(
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF111827)),
          decoration: const InputDecoration(
            isDense: true,
            hintText: 'Search conversations or products...',
            hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6B7280), size: 20),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            border: InputBorder.none,
          ),
          onChanged: onSearch,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}
