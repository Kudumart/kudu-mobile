part of '../screen.dart';

class _AppBar extends StatelessWidget {
  final String username;
  final String userAvatar;
  const _AppBar({required this.username, required this.userAvatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      height: 52,
      child: Row(
        children: [
          Image.asset(userAvatar, height: 50, width: 50),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome back,",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8C8A93))),
              Text(_formatUserName(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black))
            ],
          ),
          const Expanded(child: SizedBox()),
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
    final nameParts = username.split(' ');
    if (nameParts.length > 1) {
      // If the name has multiple parts (e.g., first and last name)
      for (final part in nameParts) {
        if (part.length <= 8) {
          return part;
        }
      }
    }

    if (username.length <= 8) {
      return username;
    }

    // If the name is a single part or all parts are longer than 8 characters
    return "${username.substring(0, 8)}.";
  }
}
