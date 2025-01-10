part of '../screen.dart';

class _CartProductCard extends StatelessWidget {
  final Product product;
  const _CartProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 9),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E2E2))),
      child: Row(
        children: [
          // product image
          SizedBox(
              height: 97,
              width: 97,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                    product.imagesUrl?.first ?? AppUiImage.brokenImageIcon,
                    fit: BoxFit.cover),
              )),
          const SizedBox(width: 13),
          Expanded(
              child: _ProductInfo(
                  name: product.name,
                  condition: product.condition,
                  formattedPrice: product.formatPrice())),
          const SizedBox(width: 24),
          const _EditAndRemove()
        ],
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final String name;
  final ProductCondition condition;
  final String formattedPrice;
  const _ProductInfo(
      {required this.name,
      required this.condition,
      required this.formattedPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(condition.printableName(),
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9E9E9E))),
        const Expanded(child: SizedBox()),
        Text(formattedPrice,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
      ],
    );
  }
}

class _EditAndRemove extends StatelessWidget {
  const _EditAndRemove();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          child: const Icon(CupertinoIcons.clear_circled_solid,
              color: Color.fromARGB(255, 240, 113, 59), size: 16),
        ),
        const _EditButton()
      ],
    );
  }
}
