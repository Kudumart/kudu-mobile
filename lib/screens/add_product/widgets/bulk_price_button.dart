part of '../screen.dart';

class _BulkPriceButton extends StatelessWidget {
  const _BulkPriceButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        height: 48,
        padding: const EdgeInsets.fromLTRB(19, 12, 15, 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFEBEFFF)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add Bulk Price",
                style: TextStyle(color: Color(0xFF1A3B5D), fontSize: 13)),
            Icon(
              CupertinoIcons.chevron_forward,
              size: 16,
              color: Color(0xFF808080),
            )
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context) {
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
            initialChildSize: 0.4, // Initial height (40% of screen)
            maxChildSize: 0.7, // Maximum height (70% of screen)
            minChildSize: 0.3, // Minimum height (30% of screen)
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: const _BulkPriceBottomSheet(),
              );
            },
          ),
        );
      },
    );
  }
}

class _BulkPriceBottomSheet extends StatelessWidget {
  const _BulkPriceBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 60, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bulk Size",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const _CustomFilledTextFormField(hint: "From 2 units"),
          const SizedBox(height: 25),
          const Text("Price Per Unit",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const _CustomFilledTextFormField(hint: "From 2 units"),
          const SizedBox(height: 35),
          AppButton(
              onPressed: () {},
              text: "Save")
        ],
      ),
    );
  }
}
