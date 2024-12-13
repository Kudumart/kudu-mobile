part of '../screen.dart';

class _LogoContainer extends StatelessWidget {
  const _LogoContainer();

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: const Color(0xFFD7D7D7),
      strokeWidth: 1,
      dashPattern: const [2.1, 2], // 2.1px dash, 2px gap
      borderType: BorderType.RRect,
      radius: const Radius.circular(11),
      child: Container(
        height: 155,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11), color: Colors.white),
        alignment: Alignment.center,
        child: Container(
          height: 133,
          width: 126,
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: AppUiColor.grey50,
              borderRadius: BorderRadius.circular(11)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppUiImage.storeDefaultLogo,
                  height: 40, width: 40, fit: BoxFit.cover),
              const SizedBox(height: 9),
              const Text(
                "Upload your logo",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
