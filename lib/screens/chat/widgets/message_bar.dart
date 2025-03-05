part of '../screen.dart';

class _MessageBar extends StatefulWidget {
  final void Function(String) onSend;
  final Function(String message,File file)? onSendWithFile;

  const _MessageBar({required this.onSend,this.onSendWithFile});

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  var formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _handleImagePick() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    if(mounted){
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xffF4F4F5),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 8,),
            if(image != null)...[
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      image: DecorationImage(
                        image: FileImage(File(image!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        if(mounted){
                          setState(() {
                            image = null;
                          });
                        }
                      },
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,

                        ),
                          child: const Icon(Icons.cancel_rounded,color: Colors.red,size: 24,),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            Container(
              color: const Color(0xffF4F4F5),
              padding: const EdgeInsets.fromLTRB(0, 10, 16, 8),
              child: Row(
                children: <Widget>[
                  /*IconButton(
                      onPressed: () {
                        _handleImagePick();
                      },
                      padding: const EdgeInsets.only(left: 8),
                      icon: const Icon(Icons.attachment_rounded,
                          color: AppUiColor.iconBlack, size: 18)),*/
                  IconButton(
                    onPressed: () {
                      _handleImagePick();
                    },
                    padding: const EdgeInsets.only(right: 8),
                    icon: SvgPicture.asset(
                      AppUiIcon.camera,
                      height: 20,
                      width: 20,
                      fit: BoxFit.cover,
                      colorFilter:
                          const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        constraints: const BoxConstraints(minHeight: 48, maxHeight: 57),
                        hintText: "Type your message here",
                        hintMaxLines: 1,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                        hintStyle: const TextStyle(fontSize: 13, color: AppUiColor.iconBlack),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                            width: 0.2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        // if((value).length < 3){
                        //   return 'Message must be at least 3 characters';
                        // }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      child: const Icon(
                        Icons.send,
                        color: AppUiColor.primary,
                        size: 24,
                      ),
                      onTap: () {
                        if(formKey.currentState!.validate()){
                          if (_textEditingController.text.isNotEmpty) {
                            if(image != null){
                              widget.onSendWithFile?.call(_textEditingController.text,File(image!.path));
                              image = null;
                            }else{
                              widget.onSend(_textEditingController.text);
                            }
                            _textEditingController.clear();
                            if(mounted){
                              setState(() {});
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
