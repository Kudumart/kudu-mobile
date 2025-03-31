import 'package:flutter/cupertino.dart';

extension BuildExtension on BuildContext{
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
extension NumExtension on num{
  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get height => SizedBox(height: toDouble());
  String get toCurrency => toStringAsFixed(2);
  String get toCurrencyFormat => toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}
extension StringExtension on String{
  String addParamsToUrl(Map<String, dynamic> params){
    if(params.isEmpty) return this;
    String url = this;
    url += '?';
    params.forEach((key, value) {
      if(value != null){
        url += '$key=$value&';
      }
    });
    url = url.substring(0, url.length - 1);
    return url;
  }
  String get capitalizeFirst => this[0].toUpperCase() + substring(1);
}