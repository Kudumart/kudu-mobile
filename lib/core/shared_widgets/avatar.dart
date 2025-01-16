import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import '../images.dart';

class UserCircleAvatar extends StatefulWidget {
  final String? url;
  final double circleRadius;
  final Size imageSize;
  const UserCircleAvatar(
    this.url, {
    required this.circleRadius,
    required this.imageSize,
    super.key,
  });

  @override
  State<UserCircleAvatar> createState() => _UserCircleAvatarState();
}

class _UserCircleAvatarState extends State<UserCircleAvatar> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isImageEmpty = true;

  Future<void> _handleImagePick() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      image = pickedImage;
      isImageEmpty = false;
    });

    if (!mounted) return;

    await Provider.of<ProfileViewModel>(context, listen: false).uploadImage(
      context: context,
      image: File(image!.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleImagePick,
      child: CircleAvatar(
        radius: widget.circleRadius,
        foregroundImage: _getImageProvider(),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    // If there's a locally picked image, use that first
    if (image != null) {
      return FileImage(File(image!.path));
    }

    // If there's a network URL, use CachedNetworkImageProvider
    if (widget.url != null) {
      return CachedNetworkImageProvider(
        widget.url!,
        errorListener: (e) {},
      );
    }

    // Default case: use placeholder avatar
    return const AssetImage(AppUiImage.userAvatar);
  }
}
