part of '../screen.dart';

class _CompleteKYCContainer extends StatelessWidget {
  final UserData userProfile;
  const _CompleteKYCContainer({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final isPending = userProfile.kycStatus == 'pending';
    final needsChanges = userProfile.kycStatus == 'rejected' ||
        userProfile.kycStatus == 'changes_requested';
    final title = isPending
        ? 'KYC Under Review'
        : needsChanges
            ? 'KYC Changes Requested'
            : 'Unverified Business Profile';
    final message = isPending
        ? 'Your details are being reviewed. We will notify you when a decision has been made.'
        : needsChanges
            ? 'Open your KYC form to update only the details that need attention.'
            : 'Complete the KYC form to become a verified vendor on Kudu';
    final buttonText = isPending
        ? 'View KYC'
        : needsChanges
            ? 'Fix KYC Details'
            : 'Complete KYC';
    return GestureDetector(
      onTap: () {
        userProfile.accountType == "Vendor"
            ? const DoKYCScreenRoute().push(context)
            : showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Switch Account'),
                  content: const Text(
                    'Would you like to switch to a vendor account? This will allow you to complete the KYC process.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(c);
                        var response = await Provider.of<HomeViewModel>(context,
                                listen: false)
                            .becomeVendor(context: context);
                        if (response) {
                          const DoKYCScreenRoute().push(context);
                          AppUiOverlay().showSuccessSnackbarMessage(context,
                              message:
                                  "You are now a vendor, please complete your KYC");
                        }
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
            Text(title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 7),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF8391A1), fontWeight: FontWeight.w600)),
            const SizedBox(height: 21),
            Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppUiColor.primary,
                borderRadius: BorderRadius.circular(9.3),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
