import 'package:kudu/models/currency_model.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';

class CurrencyService with ListenableServiceMixin {
  RxValue<List<CurrencyData>?> _currencies = RxValue<List<CurrencyData>?>(null);

  CurrencyService() {
    listenToReactiveValues([_currencies]);
  }

  List<CurrencyData>? get currencies => _currencies.value;

  set setCurrencies(List<CurrencyData>? val) => _currencies.value = val;
}
