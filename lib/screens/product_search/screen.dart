import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:provider/provider.dart';

import '../../models/enums_and_extensions.dart';
import '../../models/home/products_list_model.dart';
import '../../models/jobs/job_details_model.dart';
import '../../models/product.dart';
import '../../models/search_filter.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../providers/chat_view_model.dart';
import '../../providers/home_provider.dart';
import '../../services/country_service.dart';

part 'widgets/search_bar.dart';

class ProductSearchScreen extends StatefulWidget {
  final SearchFilter? searchFilter;
  const ProductSearchScreen({this.searchFilter, super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  late TextEditingController searchController;
  ProductsListModel? products;
  bool loading = false;
  String? _lastCountry;

  @override
  void initState() {
    super.initState();
    final initialSearch = Provider.of<HomeViewModel>(context, listen: false).searchValue;
    searchController = TextEditingController(text: initialSearch);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
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

  Future<void> getProducts({String? searchTerm, bool showLoader = false}) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final provider = Provider.of<HomeViewModel>(context, listen: false);
    final query = searchTerm ?? (searchController.text.isNotEmpty ? searchController.text : provider.searchValue);

    if (widget.searchFilter?.isSubCategory ?? false) {
      products = await provider.fetchProductsBySubCategory(
        context: context,
        subCategory: widget.searchFilter?.subCategory ?? "",
        force: true,
        search: query.isEmpty ? null : query,
        isPopular: widget.searchFilter?.trending ?? false,
      );
    } else if (widget.searchFilter?.isCondition ?? false) {
      products = await provider.fetchProductsByCondition(
        context: context,
        condition: widget.searchFilter?.condition ?? "",
        force: true,
        search: query.isEmpty ? null : query,
        isPopular: widget.searchFilter?.trending ?? false,
      );
    } else if (widget.searchFilter?.isMainCategory ?? false) {
      products = await provider.fetchProductsByCategory(
        context: context,
        categoryId: widget.searchFilter?.categoryId ?? "",
        force: true,
        search: query.isEmpty ? null : query,
        isPopular: widget.searchFilter?.trending ?? false,
      );
    } else {
      products = await provider.fetchAllProducts(
        context: context,
        search: query.isEmpty ? null : query,
        force: true,
        isPopular: widget.searchFilter?.trending ?? false,
      );
    }

    if (query.isNotEmpty && products?.data != null) {
      products!.data = provider.sortProductsByRelevance(products!.data!, query);
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (c,result){
        Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
      },
      child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.searchFilter?.category ?? "Search for Anything",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              centerTitle: false,
              bottom: SearchBarWithFilter(controller: searchController,onChanged: (s){
                _debouncer.run(() {
                  getProducts(searchTerm: s);
                });
              },),
              titleSpacing: 0,
              leading: AppBackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
                },
              ),
            ),
            body: SafeArea(
                minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24, UiConstant.horizontalPadding, 10),
                child: Builder(
                  builder: (context) {
                    if((products?.data ?? []).isEmpty && !loading){
                      return const Center(child: Text("No Products Available"));
                    }

                    if(loading){
                      return SingleChildScrollView(
                        child: Wrap(
                          direction: Axis.horizontal,
                          runSpacing: 19,
                          spacing: 5,
                          children: (["","","","","","","","","",""]).map((product) => ProductCardView1(ProductData(),isLoading: true)).toList(),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 19,
                        spacing: 5,
                        children: (products?.data ?? []).map((product) => ProductCardView1(product)).toList(),
                      ),
                    );
                  }
                )),
          ),
      ),
    );
  }
}
