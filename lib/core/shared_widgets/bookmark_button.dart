import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/images.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';

class BookmarkButton extends StatefulWidget {
  final bool _useOutlineIcon;
  final String? productId;
  const BookmarkButton.outline({super.key,this.productId}) : _useOutlineIcon = true;
  const BookmarkButton.filled({super.key,this.productId}) : _useOutlineIcon = false;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkBookmarks();
    });
  }

  Future<void> checkBookmarks() async {
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    await provider.updateBookMarks(context: context);
    if(provider.isInBookmarks(widget.productId ?? "")){
      setState(() {
        _isBookmarked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return widget._useOutlineIcon
            ? _buildOutlinedBookmark()
            : _buildFilledBookmark();
      }
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
        AppUiIcon.bookmarkFilled,
        colorFilter: ColorFilter.mode(
            _isBookmarked ? AppUiColor.primary : const Color(0xFF575757),
            BlendMode.srcIn),
      ),
    );
  }
}
