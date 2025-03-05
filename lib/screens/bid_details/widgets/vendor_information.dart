part of '../screen.dart';

class _VendorInformation extends StatelessWidget {
  final String storeID;
  final Store? store;
  const _VendorInformation(this.storeID, {this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 21, 16, 15),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(7)),
      child: Column(
        children: [
          const UserCircleAvatar("", circleRadius: 50, imageSize: Size(104, 104)),
          const SizedBox(height: 12),
          _StoreName(storeID,store: store),
        ],
      ),
    );
  }
}

class _StoreName extends StatefulWidget {
  final String storeID;
  final Store? store;
  const _StoreName(this.storeID, {this.store});

  @override
  State<_StoreName> createState() => _StoreNameState();
}

class _StoreNameState extends State<_StoreName> {
  late final Future<String> _fetchStoreNameFuture;

  @override
  void initState() {
    super.initState();
    _fetchStoreNameFuture = _fetchStoreName();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(widget.store != null){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Vendor Name:",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppUiColor.iconBlack)),
              const SizedBox(width: 5),
              Text(widget.store?.name ?? "Unavailable",
                  style: const TextStyle(
                      fontSize: 14, color: AppUiColor.textBlue))
            ],
          );
        }
        return FutureBuilder(
            future: _fetchStoreNameFuture,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                log("Error: failed to fetch store name: ${snapshot.error.toString()}");
                return const SizedBox.shrink();
              }
        
              if (snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vendor Name:",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppUiColor.iconBlack)),
                    const SizedBox(width: 5),
                    Text(snapshot.data!,
                        style: const TextStyle(
                            fontSize: 14, color: AppUiColor.textBlue))
                  ],
                );
              }
        
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              );
            });
      }
    );
  }

  Future<String> _fetchStoreName() {
    return Future.delayed(const Duration(seconds: 2)).then((_) => "Unavailable");
  }
}
