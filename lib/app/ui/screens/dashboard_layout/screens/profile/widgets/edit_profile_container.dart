part of '../screen.dart';

class _EditProfileContainer extends StatelessWidget {
  const _EditProfileContainer();

  @override
  Widget build(BuildContext context) {
    var user = AppStorage.user;
    return GestureDetector(
      onTap: () => const EditProfileScreenRoute().push(context),
      child: Container(
        height: 93,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11), color: AppUiColor.primary),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserCircleAvatar(user?.photo, circleRadius: 50, imageSize: const Size(50, 50)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  const SizedBox(height: 5),
                  const Text("Edit Profile",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Icon(CupertinoIcons.chevron_forward,
                  size: 16, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
