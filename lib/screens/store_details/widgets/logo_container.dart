part of '../screen.dart';

class _LogoContainer extends StatefulWidget {
  final GetStoreModel store;
  const _LogoContainer({required this.store});

  @override
  State<_LogoContainer> createState() => _LogoContainerState();
}

class _LogoContainerState extends State<_LogoContainer> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isImageEmpty = true;
  final List<Map<String, dynamic>> _deliveryOptions = [];

  Future<void> _handleImagePick() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      image = pickedImage;
      isImageEmpty = false;
    });

    final locationMap = json.decode(widget.store.location ??
        '{"address":"","city":"","state":"","country":""}');

    final businessHoursMap = json.decode(widget.store.businessHours ??
        '{"monday_friday":"","saturday":"","sunday":""}');

    final deliveryOptionsList =
        json.decode(widget.store.deliveryOptions ?? '[]') as List;

    setState(() {
      _deliveryOptions.clear();
      _deliveryOptions.addAll(
          deliveryOptionsList.map((option) => option as Map<String, dynamic>));
    });

    if (!mounted) return;

    await Provider.of<StoreViewModel>(context, listen: false).uploadImage(
      context: context,
      image: File(image!.path),
      storeId: widget.store.id!,
      storeName: widget.store.name!,
      address: locationMap['address'] ?? '',
      city: locationMap['city'] ?? '',
      state: locationMap['state'] ?? '',
      country: locationMap['country'] ?? '',
      businessHoursMF: businessHoursMap['monday_friday'] ?? '',
      businessHoursSAT: businessHoursMap['saturday'] ?? '',
      businessHoursSUN: businessHoursMap['sunday'] ?? '',
      currencyId: widget.store.currency!.id!,
      deliveryOption: _deliveryOptions,
      tipsOnFinding: widget.store.tipsOnFinding ?? '',
    );
  }

  Widget _buildLogoContent() {
    if (widget.store.logo!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppUiImage.storeDefaultLogo,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 9),
          const Text(
            "Upload your logo",
            style: TextStyle(fontSize: 12),
          )
        ],
      );
    }

    if (widget.store.logo != null) {
      return Image.network(
        widget.store.logo!,
        height: 133,
        width: 126,
        fit: BoxFit.cover,
      );
    }

    if (!isImageEmpty) {
      return Image.file(
        File(image!.path),
        height: 133,
        width: 126,
        fit: BoxFit.cover,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppUiImage.storeDefaultLogo,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 9),
        const Text(
          "Upload your logo",
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.store.logo!);
    return GestureDetector(
      onTap: _handleImagePick,
      child: DottedBorder(
        color: const Color(0xFFD7D7D7),
        strokeWidth: 1,
        dashPattern: const [2.1, 2],
        borderType: BorderType.RRect,
        radius: const Radius.circular(11),
        child: Container(
          height: 155,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: Container(
            height: 133,
            width: 126,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: AppUiColor.grey50,
                borderRadius: BorderRadius.circular(11)),
            child: _buildLogoContent(),
          ),
        ),
      ),
    );
  }
}
