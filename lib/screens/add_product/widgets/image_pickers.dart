part of '../screen.dart';

class _ImagePickers extends StatefulWidget {
  final Function(List<String>) onImagesSelected;
  final GetProductModel? productToEdit;

  const _ImagePickers({
    required this.onImagesSelected,
    this.productToEdit,
  });

  @override
  State<_ImagePickers> createState() => _ImagePickersState();
}

class _ImagePickersState extends State<_ImagePickers> {
  final List<String> _selectedPaths = [];
  final int maxImages = 500;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeExistingImages();
      });
    }
  }

  void _initializeExistingImages() {
    // Add main image if it exists
    if (widget.productToEdit?.imageUrl != null) {
      _selectedPaths.add(widget.productToEdit!.imageUrl!);
    }

    // Parse and add additional images if they exist
    if (widget.productToEdit?.additionalImages != null) {
      try {
        final List<dynamic> additionalImages =
            jsonDecode(widget.productToEdit!.additionalImages!);
        for (String imageUrl in additionalImages) {
          if (!_selectedPaths.contains(imageUrl)) {
            _selectedPaths.add(imageUrl);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing additional images: $e');
        }
      }
    }

    // Notify parent widget of initial images
    widget.onImagesSelected(_selectedPaths);
  }

  void _handleImageSelected(String path) {
    if (_selectedPaths.length < maxImages) {
      setState(() {
        _selectedPaths.add(path);
      });
      widget.onImagesSelected(_selectedPaths);
    }
  }

  void _handleImageRemoved(int index) {
    setState(() {
      _selectedPaths.removeAt(index);
      widget.onImagesSelected(_selectedPaths);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 69,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedPaths.length + (_selectedPaths.length < maxImages ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index < _selectedPaths.length) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                AppImage(
                  width: 69,
                  height: 69,
                  imgUrl: _selectedPaths[index].startsWith('http') ? _selectedPaths[index] : "",
                  imageFile: _selectedPaths[index].startsWith('http') ? null : File(_selectedPaths[index]),
                  borderWidth: 0.5,
                  borderColor: Colors.grey,
                  fit: BoxFit.cover,
                ),
                InkWell(
                  onTap: (){
                    _handleImageRemoved(index);
                  },
                  child: ClipRRect(borderRadius:const BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(2)),child: Container(decoration: BoxDecoration(
                    color:Colors.white,
                    border: Border.all(color: Colors.grey,width: 0.5)
                  ),child: const Icon(Icons.clear,color: Colors.red,size: 20,))),
                ),
              ],
            );
            // return _SelectedImage(
            //   imagePath: _selectedPaths[index],
            //   onRemove: () => _handleImageRemoved(index),
            //   isNetworkImage: _selectedPaths[index].startsWith('http'),
            // );
          } else {
            return _ImagePicker(
              onImagesSelected: (images){
                setState(() {
                  _selectedPaths.addAll(images);
                });
                widget.onImagesSelected(_selectedPaths);
              },
            );
          }
        },
      ),
    );
  }
}

// class _SelectedImage extends StatelessWidget {
//   final String imagePath;
//   final VoidCallback onRemove;
//   final bool isNetworkImage;
//
//   const _SelectedImage({
//     required this.imagePath,
//     required this.onRemove,
//     this.isNetworkImage = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 69,
//       height: 69,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               image: DecorationImage(
//                 image: isNetworkImage
//                     ? NetworkImage(imagePath)
//                     : FileImage(File(imagePath)) as ImageProvider,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//             right: -12,
//             top: -12,
//             child: IconButton(
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               icon: const Icon(Icons.close, color: Colors.red, size: 20),
//               onPressed: onRemove,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _ImagePicker extends StatelessWidget {
  final Function(String)? onImageSelected;
  final Function(List<String>)? onImagesSelected;
  final ImagePicker _imagePicker = ImagePicker();

  _ImagePicker({
    this.onImageSelected,
    this.onImagesSelected,
  });

  Future<void> _showImageSourceDialog(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _fromCamera();
            },
            child: const Text('Take Photo'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _fromGallery();
            },
            child: const Text('Choose from Gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> _fromCamera() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      onImageSelected?.call(pickedFile.path);
      onImagesSelected?.call([pickedFile.path]);
    }
  }

  Future<void> _fromGallery() async {
    final pickedFile = await _imagePicker.pickMultiImage(
      imageQuality: 50,
    );
    if (pickedFile.isNotEmpty) {
      onImageSelected?.call(pickedFile[0].path);
      onImagesSelected?.call(pickedFile.map((e)=> e.path).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: 69,
        height: 69,
        decoration: BoxDecoration(
          color: const Color(0x40FF6F22),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.add,
          color: Color(0xFF373737),
          size: 24,
        ),
      ),
    );
  }
}
