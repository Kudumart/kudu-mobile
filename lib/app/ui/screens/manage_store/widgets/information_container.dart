part of '../screen.dart';

class _InformationContainer extends StatelessWidget {
  final List<DataItem> information;
  const _InformationContainer(this.information);

  @override
  Widget build(BuildContext context) {
    final List<_DataItemView> items = [];
    final lastItemIndex = information.length - 1;
    for (int i = 0; i < information.length; i++) {
      items.add(_DataItemView(
        information[i],
        showBottomBorder: i < lastItemIndex,
      ));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Column(
        children: items,
      ),
    );
  }
}

class _DataItemView extends StatelessWidget {
  final DataItem item;
  final bool showBottomBorder;
  const _DataItemView(this.item, {this.showBottomBorder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.73,
      padding: const EdgeInsets.symmetric(vertical: 23),
      decoration: BoxDecoration(
          border: showBottomBorder
              ? const Border(bottom: BorderSide(color: AppUiColor.borderline))
              : null),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              const SizedBox(height: 4),
              Text(
                item.name,
                style:
                    const TextStyle(fontSize: 12.5, color: Color(0xFFB0B0B0)),
              )
            ],
          )),
          if (item.actionText != null)
            GestureDetector(
              onTap: item.onClickActionText,
              child: Text(item.actionText!,
                  style: const TextStyle(fontSize: 13, color: Colors.blue)),
            )
        ],
      ),
    );
  }
}

class DataItem {
  final String value;
  final String name;
  final String? actionText;
  final Function()? onClickActionText;

  DataItem({
    required this.value,
    required this.name,
    required this.actionText,
    required this.onClickActionText,
  }) : assert((actionText == null && onClickActionText == null) ||
            (actionText != null && onClickActionText != null));
}
