import 'package:kudu/models/payment_key_model.dart';
import 'package:kudu/models/user.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';

class PaymentGatewayKeyService with ListenableServiceMixin {
  final RxValue<PaymentData?> _paymentKey = RxValue<PaymentData?>(null);

  PaymentGatewayKeyService() {
    listenToReactiveValues([_paymentKey]);
  }

  PaymentData? get paymentKey => _paymentKey.value;

  set setPaymentKey(PaymentData? val) {
    _paymentKey.value = val;
    notifyListeners();
  }

  void clearUserData() {
    _paymentKey.value = null;
  }
}
