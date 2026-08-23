part of '../screen.dart';

class _ContactSellerButtons extends StatelessWidget {
  final String? sellerPhoneNumber;
  final ProductData? product;
  const _ContactSellerButtons({this.sellerPhoneNumber, this.product});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = StorageService().getBool('isLoggedIn') ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Message Seller Button
        Flexible(
          flex: 2,
          child: AppButton(
            onPressed: () {
              if (isLoggedIn) {
                final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
                if(chatViewModel.userDataService.userData?.id == product?.vendor?.id){
                  AppUiOverlay().showErrorSnackbarMessage(context, message: "You can't message yourself");
                  return;
                }
                var conversationListData = ConversationListData(
                  receiverId: product?.vendor?.id,
                  productId: product?.id,
                  product: ChatProduct(
                    id: product?.id,
                    name: product?.name,
                  ),
                  receiverUser: ReceiverUser(
                    id: product?.vendor?.id,
                    firstName: product?.vendor?.firstName,
                    lastName: product?.vendor?.lastName,
                    email: product?.vendor?.email,
                    phoneNumber: product?.vendor?.phoneNumber,
                    photo: product?.vendor?.photo,
                  )
                );
                ChatScreenRoute(conversationListData).push(context);
              } else {
                const SignUpOptionsScreenRoute(UserType.customer).push(context);
              }
            },
            variant: AppButtonVariant.outline,
            icon: SvgPicture.asset(AppUiIcon.chat,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    AppUiColor.primary, BlendMode.srcIn)),
            text: 'Message Seller',
          ),
        ),

        const SizedBox(width: 5),

        // Call Button
        Flexible(
          flex: 2,
          child: AppButton(
            onPressed: () {
              if (isLoggedIn) {
                final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
                if(chatViewModel.userDataService.userData?.id == product?.vendor?.id){
                  AppUiOverlay().showErrorSnackbarMessage(context, message: "You can't call yourself");
                  return;
                }
                if(product?.vendor?.phoneNumber == null){
                  AppUiOverlay().showErrorSnackbarMessage(context, message: "Phone number unavailable");
                }
                callNumber(context, product?.vendor?.phoneNumber ?? "");
              } else {
                const SignUpOptionsScreenRoute(UserType.customer).push(context);
              }
            },
            icon: SvgPicture.asset(AppUiIcon.phone,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            text: 'Call',
          ),
        ),
      ],
    );
  }
}
