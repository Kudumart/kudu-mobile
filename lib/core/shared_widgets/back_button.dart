import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  final Function()? onPressed;
  const AppBackButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed ?? context.pop,
        child: IconButton(
          padding: const EdgeInsets.fromLTRB(0, 10, 5, 8),
          onPressed: onPressed ?? context.pop,
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 22,
          ),
        ));
  }
}
