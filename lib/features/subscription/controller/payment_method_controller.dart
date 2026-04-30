import 'package:flutter/material.dart';
import 'package:yasminaarsic/features/subscription/data/payment_method_model.dart';

class PaymentController extends ChangeNotifier {
  PaymentMethod _paymentMethod = PaymentMethod();
  bool _isLoading = false;

  PaymentMethod get paymentMethod => _paymentMethod;
  bool get isLoading => _isLoading;
  bool get canSubmit => _paymentMethod.isValid && !_isLoading;

  void updateCardNumber(String value) {
    _paymentMethod = _paymentMethod.copyWith(
      cardNumber: _formatCardNumber(value),
    );
    notifyListeners();
  }

  void updateExpiryDate(String value) {
    _paymentMethod = _paymentMethod.copyWith(
      expiryDate: _formatExpiryDate(value),
    );
    notifyListeners();
  }

  void updateCVV(String value) {
    if (value.length <= 3) {
      _paymentMethod = _paymentMethod.copyWith(cvv: value);
      notifyListeners();
    }
  }

  void updateCardholderName(String value) {
    _paymentMethod = _paymentMethod.copyWith(cardholderName: value);
    notifyListeners();
  }

  String _formatCardNumber(String value) {
    final cleaned = value.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < cleaned.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(cleaned[i]);
    }
    
    return buffer.toString();
  }

  String _formatExpiryDate(String value) {
    final cleaned = value.replaceAll('/', '');
    if (cleaned.length >= 2) {
      return '${cleaned.substring(0, 2)}/${cleaned.substring(2, cleaned.length > 4 ? 4 : cleaned.length)}';
    }
    return cleaned;
  }

  Future<bool> submitPaymentMethod() async {
    if (!canSubmit) return false;

    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    return true;
  }

  void reset() {
    _paymentMethod = PaymentMethod();
    _isLoading = false;
    notifyListeners();
  }
}