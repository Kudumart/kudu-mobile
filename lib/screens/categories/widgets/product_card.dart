part of '../screen.dart';

class _ProductCard extends StatelessWidget {
  final ProductData product;
  final double maxWidth;
  final bool loading;

  const _ProductCard(this.product, {required this.maxWidth,this.loading = false});

  @override
  Widget build(BuildContext context) {
    if(loading){
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: maxWidth,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(11.0),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: maxWidth * 0.8,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      width: maxWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(
            imgUrl: productImages.firstOrNull ?? "",
            radius: 6,
            height: 176, width: maxWidth,
            fit: BoxFit.cover,
            backgroundColor: Colors.grey[300]!,
            borderWidth: 1,
          ),
          const SizedBox(height: 15),
          Text(
            product.name ?? "",
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9E9E9E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<String> get productImages{
    var listToReturn = <String>[];
    if(product.imageUrl != null){
      listToReturn.add(product.imageUrl ?? "");
    }
    if(product.additionalImages != null){
      product.additionalImages?.forEach((e){
        listToReturn.add(e.toString());
      });
    }
    listToReturn = listToReturn.toSet().toList();
    return listToReturn;
  }

  String formatPrice() {
    final format = NumberFormat.currency(locale: "en-US", symbol: product.store?.currency?.symbol ?? "\$");
    return format.format(num.tryParse(product.price ?? "") ?? 0);
  }

  String get description{
    var description = product.description;
    var otherDetails = product.specification;
    if((description ?? "").isEmpty && (otherDetails ?? "").isEmpty){
      return "Seller didn't provide any description of this product at this time. Kindly reach out to the seller to get more direct and up-to-date information about the product";
    }

    return "${description?.trim()}\n\n${otherDetails?.trim()}";
  }

  String get location{
    if(product.vendor == null){
      return "Not Available";
    }
    var city = product.vendor?.location["city"]?.toString().trim() ?? "";
    var state = product.vendor?.location["state"]?.toString().trim() ?? "";
    var country = product.vendor?.location["country"]?.toString().trim() ?? "";

    var stringToReturn = city;
    if(city != state && state != ""){
      stringToReturn += ", $state";
    }
    if(city != country && country != ""){
      stringToReturn += ", $country";
    }
    return stringToReturn;
  }
}
