part of '../screen.dart';

class _EmptyStoreView extends StatelessWidget {
  const _EmptyStoreView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Image.asset(
              AppUiImage.noStore,
            )),
        const SizedBox(height: 41),
        const Text("Empty Store!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
        const SizedBox(height: 19),
        const Text(
            "Want to reach more customers? Kudu let's you create and manage your own store.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        const SizedBox(height: 30),
        AppButton(
          text: "Create My Store",
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              isScrollControlled: true,
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
                    initialChildSize: 0.6,
                    maxChildSize: 0.9,
                    minChildSize: 0.3,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: const CreateStoreForms(),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
