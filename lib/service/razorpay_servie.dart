import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {

  final Razorpay _razorpay = Razorpay();

  void startPayment(int amount, String name) {

    var options = {
      'key': 'rzp_test_YOUR_KEY_HERE', // 🔥 replace with your key
      'amount': amount * 100,
      'name': 'SupportHive',
      'description': 'Session with $name',
      'prefill': {
        'contact': '9999999999',
        'email': 'test@gmail.com'
      }
    };

    _razorpay.open(options);

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      print("SUCCESS");
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      print("ERROR");
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
      print("WALLET");
    });
  }
}