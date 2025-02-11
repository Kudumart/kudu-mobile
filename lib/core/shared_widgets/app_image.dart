import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppImage extends StatefulWidget {
  const AppImage({
    super.key,
    this.imgUrl = '',
    this.radius = 10,
    this.width = 100,
    this.height = 100,
    this.borderWidth = 0,
    this.backgroundColor = Colors.grey,
    this.borderColor = Colors.transparent,
    this.bytes,
    this.isContact = false,
    this.contactName = '',
    this.imagePlaceholder,
    this.imageFile,
    this.useCachedImage = true,
    this.usePlaceHolder = false,
    this.useTextPlaceholder = false,
    this.useImagePlaceholder = false, this.placeHolderColor,
    this.fit = BoxFit.scaleDown,
  });

  final String imgUrl;
  final double radius;
  final double? width;
  final double? height;
  final double borderWidth;
  final Color backgroundColor;
  final Color borderColor;
  final Color? placeHolderColor;
  final Uint8List? bytes;
  final File? imageFile;
  final String contactName;
  final Widget? imagePlaceholder;
  final bool isContact;
  final bool usePlaceHolder;
  final bool useCachedImage;
  final bool useTextPlaceholder;
  final bool useImagePlaceholder;
  final BoxFit fit;

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  bool useCachedImage = true;

  @override
  void initState() {
    super.initState();
    useCachedImage = widget.useCachedImage;
    if(!useCachedImage){
      CachedNetworkImage.evictFromCache(widget.imgUrl).then((value) {
        if(mounted){
          setState(() {});
        }
      });
    }
  }

  Widget _textPlaceholder(){
    var nameToDisplay = '';
    if(widget.contactName.split(' ').length >= 2){
      final names = widget.contactName.split(' ');
      nameToDisplay = names[0][0] + names[1][0];
    }else if(widget.contactName.length > 1){
      final names = widget.contactName.split(' ');
      if(names.length > 1){
        nameToDisplay = names[0][0] + names[1][0];
      }else{
        nameToDisplay = names[0][0];
      }
    }else if(widget.contactName.isNotEmpty){
      nameToDisplay = widget.contactName[0];
    }
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: Builder(
            builder: (context) => Center(
              child: Text(
                nameToDisplay,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.placeHolderColor ?? Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(){
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: Builder(
            builder: (context) => widget.imagePlaceholder ?? Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(){
    if(!widget.usePlaceHolder){
      return const SizedBox.shrink();
    }
    if(widget.useTextPlaceholder){
      return _textPlaceholder();
    }else if(widget.useImagePlaceholder){
      return _imagePlaceholder();
    }else {
      return const SizedBox.shrink();
    }
  }

  bool get isAssetUrl{
    return widget.imgUrl.startsWith('assets/');
  }

  bool get isSvgUrl{
    return widget.imgUrl.endsWith('.svg');
  }

  bool get isUrl{
    return widget.imgUrl.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if(widget.bytes != null){
      child = Image.memory(
        widget.bytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }else if(widget.imageFile != null){
      child = Image.file(
        widget.imageFile!,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }else if(widget.imgUrl == 'null' || widget.imgUrl.trim().isEmpty){
      child = _placeholder();
    }else if(isAssetUrl){
      if(isSvgUrl){
        child = SvgPicture.asset(
          widget.imgUrl,
          fit: widget.fit,
          colorFilter: widget.placeHolderColor != null ? ColorFilter.mode(widget.placeHolderColor!, BlendMode.srcIn) : null,
          placeholderBuilder: (context) => _placeholder(),
        );
      }else{
        child = Image.asset(
          widget.imgUrl,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      }
    } else{
      child = CachedNetworkImage(
        imageUrl: widget.imgUrl,
        fit: widget.fit,
        errorWidget: (context, url, error) => _placeholder(),
        placeholder: (context, url) => _placeholder(),
        width: widget.width,
        height: widget.height,
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: child,
        ),
      ),
    );
  }
}
