part of '../screen.dart';

class _MessageBar extends StatefulWidget {
  final void Function(String) onSend;

  const _MessageBar({required this.onSend});

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: const Color(0xffF4F4F5),
          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {},
                  padding: const EdgeInsets.only(left: 8),
                  icon: const Icon(Icons.attachment_rounded,
                      color: AppUiColor.iconBlack, size: 18)),
              IconButton(
                  onPressed: () {},
                  padding: const EdgeInsets.only(right: 8),
                  icon: SvgPicture.asset(
                    AppUiIcon.camera,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                    colorFilter:
                        const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                  )),
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    constraints:
                        const BoxConstraints(minHeight: 48, maxHeight: 57),
                    hintText: "Type your message here",
                    hintMaxLines: 1,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10),
                    hintStyle: const TextStyle(
                        fontSize: 13, color: AppUiColor.iconBlack),
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
                    if (_textEditingController.text.isNotEmpty) {
                      widget.onSend(_textEditingController.text);
                      _textEditingController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
