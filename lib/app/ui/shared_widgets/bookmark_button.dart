import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';

class BookmarkButton extends StatefulWidget {
  final bool _useOutlineIcon;
  const BookmarkButton.outline({super.key}) : _useOutlineIcon = true;
  const BookmarkButton.filled({super.key}) : _useOutlineIcon = false;

  @override
  BookmarkButtonState createState() => BookmarkButtonState();
}

class BookmarkButtonState extends State<BookmarkButton> {
  bool _isBookmarked = false;

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleBookmark,
      child: widget._useOutlineIcon
          ? _buildOutlinedBookmark()
          : _buildFilledBookmark(),
    );
  }

  Widget _buildOutlinedBookmark() {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        shape: BoxShape.circle,
      ),
      child: Icon(
        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.orange,
        size: 18,
      ),
    );
  }

  Widget _buildFilledBookmark() {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: const Color(0xFFF4F4F4)),
      child: SvgPicture.asset(
        UiIcon.bookmarkFilled,
        colorFilter: ColorFilter.mode(
            _isBookmarked ? UiColor.primary : const Color(0xFF575757),
            BlendMode.srcIn),
      ),
    );
  }
}
