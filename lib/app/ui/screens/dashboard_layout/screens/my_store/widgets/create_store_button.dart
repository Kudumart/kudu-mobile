part of '../screen.dart';

class _AddNewStoreButton extends StatelessWidget {
  final Function(Store) onAddNewStore;
  const _AddNewStoreButton({required this.onAddNewStore});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => _openBottomSheet(context),
        child: const Text("Add New",
            style: TextStyle(fontSize: 14, color: AppUiColor.textBlue)));
  }

  _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // To ensure content is visible with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6, // Initial height (60% of screen)
            maxChildSize: 0.9, // Maximum height (90% of screen)
            minChildSize: 0.3, // Minimum height (30% of screen)
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: _CreateStoreForms(onClickCreateStore: onAddNewStore,),
              );
            },
          ),
        );
      },
    );
  }
}
