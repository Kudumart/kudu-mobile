import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/app_image.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../models/services/service_models.dart';
import '../../providers/home_provider.dart';
import 'detail_screen.dart';

part 'widgets/service_card.dart';

class ServicesMarketplaceScreen extends StatefulWidget {
  const ServicesMarketplaceScreen({super.key});

  @override
  State<ServicesMarketplaceScreen> createState() => _ServicesMarketplaceScreenState();
}

class _ServicesMarketplaceScreenState extends State<ServicesMarketplaceScreen> {
  bool loading = true;
  bool loadingMore = false;
  List<ServiceCategory> categories = [];
  List<ServiceCategory> subCategories = [];
  String? selectedCategoryId;
  String? selectedSubCategoryId;
  List<ServiceData> services = [];
  int currentPage = 1;
  int totalPages = 1;

  late HomeViewModel provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        loadCategories(),
        loadServices(),
      ]);
    });
  }

  Future<void> loadCategories() async {
    var result = await provider.fetchServiceCategories();
    if (mounted) {
      setState(() {
        categories = result;
      });
    }
  }

  Future<void> loadSubCategories(String categoryId) async {
    var result = await provider.fetchServiceSubCategories(categoryId);
    if (mounted) {
      setState(() {
        subCategories = result;
      });
    }
  }

  Future<void> loadServices({bool resetPage = true}) async {
    if (mounted) {
      setState(() {
        if (resetPage) {
          loading = true;
          currentPage = 1;
        } else {
          loadingMore = true;
        }
      });
    }
    var result = await provider.fetchServices(
      categoryId: selectedCategoryId,
      subCategoryId: selectedSubCategoryId,
      page: currentPage,
    );
    if (mounted) {
      setState(() {
        if (resetPage) {
          services = result?.data ?? [];
        } else {
          services.addAll(result?.data ?? []);
        }
        totalPages = result?.pagination?.totalPages ?? 1;
        loading = false;
        loadingMore = false;
      });
    }
  }

  void onCategorySelected(String? categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedSubCategoryId = null;
      subCategories = [];
    });
    if (categoryId != null) {
      loadSubCategories(categoryId);
    }
    loadServices();
  }

  void onSubCategorySelected(String? subCategoryId) {
    setState(() {
      selectedSubCategoryId = subCategoryId;
    });
    loadServices();
  }

  Future<void> loadNextPage() async {
    if (loadingMore || currentPage >= totalPages) return;
    currentPage++;
    await loadServices(resetPage: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUiColor.ghostWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        leading: AppBackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 15, UiConstant.horizontalPadding, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (categories.isNotEmpty) ...[
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                      label: "All",
                      selected: selectedCategoryId == null,
                      onTap: () => onCategorySelected(null),
                    ),
                    ...categories.map((category) => _FilterChip(
                          label: category.name ?? "",
                          selected: selectedCategoryId == category.id,
                          onTap: () => onCategorySelected(category.id),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            if (subCategories.isNotEmpty) ...[
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                      label: "All",
                      outlined: true,
                      selected: selectedSubCategoryId == null,
                      onTap: () => onSubCategorySelected(null),
                    ),
                    ...subCategories.map((sub) => _FilterChip(
                          label: sub.name ?? "",
                          outlined: true,
                          selected: selectedSubCategoryId == sub.id,
                          onTap: () => onSubCategorySelected(sub.id),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : services.isEmpty
                      ? const Center(child: Text("No services found"))
                      : RefreshIndicator(
                          onRefresh: () => loadServices(),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
                                loadNextPage();
                              }
                              return false;
                            },
                            child: GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.62,
                              ),
                              itemCount: services.length,
                              itemBuilder: (_, index) {
                                var service = services[index];
                                return _ServiceCard(
                                  service: service,
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ServiceDetailScreen(serviceId: service.id ?? ""),
                                    ));
                                  },
                                );
                              },
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool outlined;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppUiColor.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppUiColor.primary : Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
