part of '../screen.dart';

// part of '../my_store_screen.dart';

class _StoreInfoCard extends StatelessWidget {
  final GetStoreModel store;
  const _StoreInfoCard(this.store);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(store.id ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Store'),
            content: const Text(
              'Are you sure you want to delete this store? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          // Delete the store
          await Provider.of<HomeViewModel>(context, listen: false).deleteStore(
            context: context,
            storeId: store.id!,
          );
        }

        // Return the confirmation result to determine if the item should be dismissed
        return confirmed ?? false;
      },
      background: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(9),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          StoreDetailsScreenRoute(store).push(context);
        },
        child: Container(
          height: 88,
          padding: const EdgeInsets.fromLTRB(10, 20, 14, 20),
          decoration: BoxDecoration(
            border: Border.all(color: AppUiColor.borderline),
            borderRadius: BorderRadius.circular(9),
            color: Colors.white,
          ),
          child: Row(
            children: [
              _BuildingIcon(
                store: store,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2075B6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        text: "created: ",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: formatDate(
                                store.createdAt!, [dd, " ", MM, ", ", yyyy]),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppUiColor.primary,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (store.isVerified!)
                Image.asset(
                  AppUiImage.blueCheckmark,
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildingIcon extends StatelessWidget {
  final GetStoreModel store;
  const _BuildingIcon({required this.store});

  @override
  Widget build(BuildContext context) {
    return AppImage(
      radius: 360,
      height: 47,
      width: 47,
      backgroundColor: AppUiColor.primary,
      imgUrl: (store.logo?.trim() ?? "").isNotEmpty ? store.logo! : AppUiIcon.building,
      placeHolderColor: Colors.white,
    );
    return store.logo != ''
        ? Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(store.logo!),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container(
            height: 47,
            width: 47,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppUiColor.primary,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppUiIcon.building,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          );
  }
}
