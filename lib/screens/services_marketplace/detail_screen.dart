import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/app_image.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../models/services/service_models.dart';
import '../../providers/home_provider.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;
  const ServiceDetailScreen({required this.serviceId, super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  ServiceData? service;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var result = await Provider.of<HomeViewModel>(context, listen: false).fetchServiceById(widget.serviceId);
      if (mounted) {
        setState(() {
          service = result;
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        leading: AppBackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : service == null
              ? const Center(child: Text("Service not found"))
              : SafeArea(
                  minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppImage(
                            imgUrl: service?.imageUrl ?? "",
                            fit: BoxFit.cover,
                            height: 220,
                            width: double.infinity,
                            borderColor: Colors.transparent,
                            radius: 0,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          service?.title ?? "",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (service?.category?.name != null) ...[
                              _Badge(text: service!.category!.name!),
                              const SizedBox(width: 6),
                            ],
                            if (service?.subCategory?.name != null) ...[
                              _Badge(text: service!.subCategory!.name!),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (service?.hasDiscount == true) ...[
                              Text(
                                "₦${service?.discountPrice}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppUiColor.primary),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "₦${service?.price}",
                                style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
                              ),
                            ] else ...[
                              Text(
                                "₦${service?.price}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppUiColor.primary),
                              ),
                            ],
                            if (service?.isNegotiable == true) ...[
                              const SizedBox(width: 8),
                              _Badge(text: "Negotiable"),
                            ],
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(color: AppUiColor.borderline, height: 1),
                        const SizedBox(height: 15),
                        const Text(
                          "Description",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (service?.description ?? "").trim().isEmpty
                              ? "No description provided."
                              : service!.description!,
                          style: const TextStyle(fontSize: 14, color: AppUiColor.iconBlack),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppUiColor.iconBlack),
                            const SizedBox(width: 4),
                            Expanded(child: Text(service?.location ?? "Not Available", style: const TextStyle(fontSize: 13, color: AppUiColor.iconBlack))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.work_outline, size: 16, color: AppUiColor.iconBlack),
                            const SizedBox(width: 4),
                            Text("${service?.workExperienceYears ?? 0} yrs experience", style: const TextStyle(fontSize: 13, color: AppUiColor.iconBlack)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(color: AppUiColor.borderline, height: 1),
                        const SizedBox(height: 15),
                        const Text(
                          "Provider",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            AppImage(
                              imgUrl: service?.provider?.photo ?? "",
                              radius: 360,
                              height: 44,
                              width: 44,
                              usePlaceHolder: true,
                              useTextPlaceholder: true,
                              placeHolderColor: Colors.white,
                              contactName: (service?.provider?.name ?? "").isEmpty ? "?" : service!.provider!.name,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      service?.provider?.name ?? "",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                    ),
                                    if (service?.provider?.isVerified == true) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified, size: 14, color: Colors.green),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppUiColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppUiColor.primary.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppUiColor.primary),
      ),
    );
  }
}
