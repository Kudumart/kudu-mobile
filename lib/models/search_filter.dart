class SearchFilter {
  final String? category;
  final String? subCategory;
  final String? categoryId;
  final String? condition;
  final bool trending;
  final bool isMainCategory;
  final bool isSubCategory;
  final bool isCondition;

  SearchFilter({this.category, this.subCategory,this.categoryId,this.condition,this.trending = false,this.isMainCategory = true,this.isSubCategory = false,this.isCondition = false});
}