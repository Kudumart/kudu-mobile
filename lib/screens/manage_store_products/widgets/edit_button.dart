part of '../screen.dart';

class _EditButton extends StatelessWidget {
  final GetStoreModel store;
  final GetProductModel product;

  const _EditButton(this.store, this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AddProductScreenRoute(product, storeId: store.id, isEditing: true).push(context),
      child: Container(
        height: 25,
        width: 55,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.pen, color: Colors.white, size: 16),
            SizedBox(width: 5),
            Text(
              "Edit",
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}
