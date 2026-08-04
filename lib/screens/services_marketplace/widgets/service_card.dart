part of '../screen.dart';

class _ServiceCard extends StatelessWidget {
  final ServiceData service;
  final VoidCallback onTap;
  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: AppImage(
                imgUrl: service.imageUrl ?? "",
                fit: BoxFit.cover,
                height: 100,
                width: double.infinity,
                borderColor: Colors.transparent,
                radius: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title ?? "",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (service.category?.name != null) ...[
                    Text(
                      service.category?.name ?? "",
                      style: const TextStyle(fontSize: 11, color: AppUiColor.iconBlack),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    children: [
                      if (service.hasDiscount) ...[
                        Text(
                          "₦${service.discountPrice}",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppUiColor.primary),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "₦${service.price}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else ...[
                        Text(
                          "₦${service.price}",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppUiColor.primary),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.provider?.name ?? "",
                          style: const TextStyle(fontSize: 11, color: AppUiColor.iconBlack),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (service.provider?.isVerified == true) ...[
                        const Icon(Icons.verified, size: 14, color: Colors.green),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
