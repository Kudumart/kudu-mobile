part of '../../../screen.dart';

class _StoreName extends StatefulWidget {
  final String storeID;
  const _StoreName(this.storeID);

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
    return FutureBuilder(
        future: _fetchStoreNameFuture,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            log("Error: failed to fetch store name: ${snapshot.error.toString()}");
            return const SizedBox.shrink();
          }

          if (snapshot.hasData) {
            return RichText(
                text: TextSpan(
                    text: "Vendor: ",
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    children: [
                  TextSpan(
                      text: snapshot.data!,
                      style: const TextStyle(
                          fontSize: 12, color: AppUiColor.primary))
                ]));
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

  Future<String> _fetchStoreName() {
    return Future.delayed(const Duration(seconds: 2)).then((_) => "Greenmouse");
  }
}
