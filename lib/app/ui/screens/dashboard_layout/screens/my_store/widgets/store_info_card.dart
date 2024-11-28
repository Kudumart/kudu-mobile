part of '../screen.dart';

class _StoreInfoCard extends StatelessWidget {
  final Store store;
  const _StoreInfoCard(this.store);

  @override
  Widget build(BuildContext context) {
    final verificationStatus = store.verified ? "Verified" : "Unverified";
    return GestureDetector(
      onTap: () => const ManageStoreScreenRoute().push(context),
      child: Container(
        height: 88,
        padding: const EdgeInsets.fromLTRB(10, 20, 14, 20),
        decoration: BoxDecoration(
            border: Border.all(color: AppUiColor.borderline),
            borderRadius: BorderRadius.circular(9),
            color: Colors.white),
        child: Row(
          children: [
            const _BuildingIcon(),
            const SizedBox(width: 5),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store.name,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF2075B6))),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                      text: "Status:  ",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      children: [
                        TextSpan(
                            text: verificationStatus,
                            style: const TextStyle(
                                fontSize: 12, color: AppUiColor.primary))
                      ]),
                )
              ],
            )),
            Image.asset(
              AppUiImage.blueCheckmark,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}

class _BuildingIcon extends StatelessWidget {
  const _BuildingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      width: 47,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: AppUiColor.primary, shape: BoxShape.circle),
      child: SvgPicture.asset(
        AppUiIcon.building,
        height: 20,
        width: 20,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
