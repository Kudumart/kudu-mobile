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
      ],
    );
  }
}
