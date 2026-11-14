part of '../screen.dart';

class _TrendingProductPagedView extends StatefulWidget {
  const _TrendingProductPagedView();

  @override
  State<_TrendingProductPagedView> createState() =>
      _TrendingProductPagedViewState();
}

class _TrendingProductPagedViewState extends State<_TrendingProductPagedView> {
  final PageController _pageController = PageController();
  List<_TwoProductsRowPage>? _twoProductsPerPage;
  int _activeIndex = 0;
  int length = 2;

  String? _lastCountry;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentCountry = Provider.of<CountryService>(context).selectedCountryValue;
    if (_lastCountry != currentCountry) {
      _lastCountry = currentCountry;
      getProducts();
    }
  }

  ProductsListModel? products;
  Future<void> getProducts() async {
    products = await Provider.of<HomeViewModel>(context, listen: false).fetchAllProducts(
      context: context,
      isPopular: true,
      force: true,
    );
    if (products?.data?.isNotEmpty ?? false) {
      final list = products?.data ?? [];
      _twoProductsPerPage = [];
      for (var index = 0; index < list.length; index += 2) {
        final end = index + 2 < list.length ? index + 2 : list.length;
        _twoProductsPerPage!.add(
          _TwoProductsRowPage(list.sublist(index, end)),
        );
      }
      length = _twoProductsPerPage?.length ?? 2;
    } else {
      _twoProductsPerPage = [];
      length = 0;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _twoProductsPerPage?.length ?? length;
    return SizedBox(
      height: 335,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: _changeActiveIndex,
                  children: _twoProductsPerPage ?? [
                    _TwoProductsRowPage([ProductData(), ProductData()], loading: true),
                    _TwoProductsRowPage([ProductData(), ProductData()], loading: true),
                  ],
                ),
                if (totalPages > 1 && _activeIndex > 0)
                  Positioned(
                    left: 2,
                    child: _NavArrowButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                if (totalPages > 1 && _activeIndex < totalPages - 1)
                  Positioned(
                    right: 2,
                    child: _NavArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (totalPages > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                "${_activeIndex + 1} of $totalPages",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _changeActiveIndex(int newIndex) {
    setState(() => _activeIndex = newIndex);
  }
}

class _NavArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: Colors.black87),
        ),
      ),
    );
  }
}

class _TwoProductsRowPage extends StatelessWidget {
  final List<ProductData> products;
  final bool loading;
  const _TwoProductsRowPage(this.products,{this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ProductCardView1(products[0],isLoading: loading),
      const SizedBox(width: 10),
      if (products.length > 1) ProductCardView1(products[1],isLoading: loading),
    ]);
  }
}
