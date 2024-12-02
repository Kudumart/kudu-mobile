part of '../screen.dart';

class _ImagePickers extends StatefulWidget {
  const _ImagePickers();

  @override
  State<_ImagePickers> createState() => _ImagePickersState();
}

class _ImagePickersState extends State<_ImagePickers> {
  late final List<_ImagePicker> _pickers;

  @override
  void initState() {
    super.initState();
    _pickers = const [_ImagePicker()];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        runSpacing: 8,
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8,
        children: _pickers);
  }
}

class _ImagePicker extends StatefulWidget {
  const _ImagePicker();

  @override
  State<_ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<_ImagePicker> {
  String _path = "";
  late XFile? _pickedFile = XFile(_path);
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      width: 69,
      decoration: BoxDecoration(
        color: const Color(0x40FF6F22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.add,
        color: Color(0xFF373737),
        size: 24,
      ),
    );
  }

  void _fromCamera() async {
    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _path = pickedFile.path;
      });
    }
  }
}
