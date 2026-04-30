class PaymentMethod {
  String cardNumber;
  String expiryDate;
  String cvv;
  String cardholderName;

  PaymentMethod({
    this.cardNumber = '',
    this.expiryDate = '',
    this.cvv = '',
    this.cardholderName = '',
  });

  bool get isValid {
    return cardNumber.isNotEmpty &&
        expiryDate.isNotEmpty &&
        cvv.isNotEmpty &&
        cardholderName.isNotEmpty &&
        _isValidCardNumber() &&
        _isValidExpiryDate() &&
        _isValidCVV();
  }

  bool _isValidCardNumber() {
    final cleaned = cardNumber.replaceAll(' ', '');
    return cleaned.length == 16 && int.tryParse(cleaned) != null;
  }

  bool _isValidExpiryDate() {
    final parts = expiryDate.split('/');
    if (parts.length != 2) return false;
    
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;
    
    if (year < currentYear) return false;
    if (year == currentYear && month < currentMonth) return false;
    
    return true;
  }

  bool _isValidCVV() {
    return cvv.length == 3 && int.tryParse(cvv) != null;
  }

  PaymentMethod copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
  }) {
    return PaymentMethod(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardholderName: cardholderName ?? this.cardholderName,
    );
  }
}