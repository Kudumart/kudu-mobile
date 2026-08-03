part of '../screen.dart';

const int _kAutocompleteMinChars = 2;
const int _kAutocompleteDebounceMs = 250;

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  var searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  Timer? _debounce;
  OverlayEntry? _overlayEntry;
  List<ProductData> _suggestions = [];
  bool _loading = false;
  String _lastQuery = "";

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < _kAutocompleteMinChars) {
      setState(() {
        _suggestions = [];
      });
      _removeOverlay();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: _kAutocompleteDebounceMs), () {
      _runSearch(value.trim());
    });
  }

  Future<void> _runSearch(String query) async {
    if (!mounted) return;
    _lastQuery = query;
    setState(() {
      _loading = true;
    });
    final provider = Provider.of<HomeViewModel>(context, listen: false);
    final results = await provider.fetchAutocompleteSuggestions(query);
    if (!mounted || query != _lastQuery) return;
    setState(() {
      _loading = false;
      _suggestions = results;
    });
    if (_suggestions.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap outside the dropdown to dismiss it.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeOverlay,
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 52),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 380),
                child: _SuggestionsList(
                  suggestions: _suggestions,
                  query: _lastQuery,
                  onSelectProduct: _onSelectProduct,
                  onViewAllResults: () => _goToSearchResults(_lastQuery),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSelectProduct(ProductData product) {
    _removeOverlay();
    _focusNode.unfocus();
    searchController.clear();
    if (product.id != null) {
      ProductDetailsScreenRoute(product.id!).push(context);
    }
  }

  void _goToSearchResults(String query) {
    if (query.trim().isEmpty) return;
    _removeOverlay();
    _focusNode.unfocus();
    searchController.clear();
    Provider.of<HomeViewModel>(context, listen: false).searchValue = query;
    ProductSearchScreenRoute(SearchFilter(isSearch: true)).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          controller: searchController,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onChanged: _onQueryChanged,
          onFieldSubmitted: (s) => _goToSearchResults(s),
          decoration: InputDecoration(
            constraints: const BoxConstraints(minHeight: 46, maxHeight: 47),
            filled: true,
            fillColor: AppUiColor.ghostWhite,
            hintText: 'Enter search keyword',
            hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                AppUiIcon.search,
                height: 21,
                width: 21,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(AppUiColor.iconBlack, BlendMode.srcIn),
              ),
            ),
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.fromLTRB(0, 16.0, 16, 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppUiColor.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppUiColor.borderline),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final List<ProductData> suggestions;
  final String query;
  final void Function(ProductData) onSelectProduct;
  final VoidCallback onViewAllResults;

  const _SuggestionsList({
    required this.suggestions,
    required this.query,
    required this.onSelectProduct,
    required this.onViewAllResults,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: suggestions.length + 1,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == suggestions.length) {
          return ListTile(
            onTap: onViewAllResults,
            title: Text(
              'View all results for "$query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppUiColor.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          );
        }

        final product = suggestions[index];
        final price = double.tryParse(product.price ?? '0') ?? 0;
        final currencySymbol = product.store?.currency?.symbol ?? '₦';
        final categoryName = product.subCategory?.name?.trim();

        return ListTile(
          onTap: () => onSelectProduct(product),
          leading: AppImage(
            imgUrl: product.imageUrl ?? '',
            width: 40,
            height: 40,
            radius: 8,
            usePlaceHolder: true,
            useImagePlaceholder: true,
          ),
          title: _HighlightedText(text: product.name ?? '', match: query),
          subtitle: Text(
            PriceFormatter.formatPrice(price: price, currency: currencySymbol),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: (categoryName == null || categoryName.isEmpty)
              ? null
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppUiColor.ghostWhite,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categoryName,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
        );
      },
    );
  }
}

/// Renders [text] with the first case-insensitive occurrence of [match]
/// highlighted, mirroring the web search bar's suggestion highlighting.
class _HighlightedText extends StatelessWidget {
  final String text;
  final String match;

  const _HighlightedText({required this.text, required this.match});

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500);

    if (match.trim().isEmpty) {
      return Text(text, style: baseStyle, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final lowerText = text.toLowerCase();
    final lowerMatch = match.toLowerCase();
    final index = lowerText.indexOf(lowerMatch);

    if (index == -1) {
      return Text(text, style: baseStyle, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + match.length),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppUiColor.primary,
              backgroundColor: Color(0x33FF6F22),
            ),
          ),
          TextSpan(text: text.substring(index + match.length)),
        ],
      ),
    );
  }
}
