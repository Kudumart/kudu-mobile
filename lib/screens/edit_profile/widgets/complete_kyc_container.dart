part of '../screen.dart';

class _CompleteKYCContainer extends StatelessWidget {
  final UserData userProfile;
  _CompleteKYCContainer({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        userProfile.accountType == "Vendor"
            ? const DoKYCScreenRoute().push(context)
            : showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Switch Account'),
                  content: const Text(
                    'Would you like to switch to a vendor account? This will allow you to complete the KYC process.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // const DoKYCScreenRoute().push(context);
                      },
                      child: const Text('Switch to Vendor'),
                    ),
                  ],
                ),
              );
      },
      child: Container(
        height: 300,
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(23, 10, 23, 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEBEFFF),
          borderRadius: BorderRadius.circular(8.33),
        ),
        child: Column(
          children: [
            Image.asset(
              AppUiImage.illustrationDocument,
              height: 132,
              width: 132,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 13),
            const Text("Unverified Business Profile",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 7),
            const Text(
                "Complete the KYC form to become a verified vendor on Kudu",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF8391A1), fontWeight: FontWeight.w600)),
            const SizedBox(height: 21),
            Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppUiColor.primary,
                borderRadius: BorderRadius.circular(9.3),
              ),
              child: const Text(
                "Complete KYC",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
