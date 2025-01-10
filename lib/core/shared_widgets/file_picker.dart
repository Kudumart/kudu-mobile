import 'package:flutter/widgets.dart';

class FilePickerBar extends StatelessWidget {
  final Function(String url) onUploadSuccessful;

  const FilePickerBar({required this.onUploadSuccessful, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      
    );
  }
}