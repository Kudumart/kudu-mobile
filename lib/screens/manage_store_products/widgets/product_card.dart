part of '../screen.dart';

class _CartProductCard extends StatelessWidget {
  final GetProductModel product;
  final GetStoreModel store;

  const _CartProductCard(
    this.product,
    this.store,
  );

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
          AppImage(
            imgUrl: product.imageUrl ?? product.additionalImages?.firstOrNull ?? "",
            height: 97,
            width: 97,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: _ProductInfo(
              name: product.name!,
              condition: product.condition?.toProductCondition.printableName() ?? "",
              formattedPrice: product.price!,
            ),
          ),
          const SizedBox(width: 24),
          _EditAndRemove(
            product: product,
            store: store,
          )
        ],
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final String name;
  final String condition;
  final String formattedPrice;
  const _ProductInfo({
    required this.name,
    required this.condition,
    required this.formattedPrice,
  });

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
        Text(condition,
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
  final GetProductModel product;
  final GetStoreModel store;
  const _EditAndRemove({
    required this.product,
    required this.store,
  });

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context1).pop();
                if(product.isAuction){
                  Provider.of<StoreViewModel>(context, listen: false).deleteAuctionProduct(
                    context: context,
                    productId: product.id!,
                  );
                }else{
                  Provider.of<StoreViewModel>(context, listen: false).deleteProduct(
                    context: context,
                    productId: product.id!,
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkResponse(
          onTap: () => _showDeleteConfirmation(context),
          child: const Icon(
            Icons.delete,
            color: Color.fromARGB(255, 240, 113, 59),
            size: 16,
          ),
        ),
        _EditButton(store, product),
      ],
    );
  }
}
