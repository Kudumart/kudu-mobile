import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: context.pop,
        child: const Icon(
          CupertinoIcons.arrow_left,
          size: 22,
        ));
  }
}
