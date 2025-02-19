class SearchFilter {
  final String? category;
  final String? subCategory;
  final String? categoryId;
  final String? condition;
  final bool trending;
  final bool isMainCategory;
  final bool isSubCategory;
  final bool isCondition;
  final bool isSearch;

  SearchFilter({this.category, this.subCategory,this.categoryId,this.condition,this.trending = false,this.isMainCategory = false,this.isSubCategory = false,this.isCondition = false,this.isSearch = false});
}