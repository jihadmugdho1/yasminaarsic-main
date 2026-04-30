class QrOffer {
  final String qrCode;
  final String title;
  final String? description;
  final String vendor;
  final String location;
  final String validUntil;
  final bool isRedeemed;
  final bool isReuseable;

  QrOffer({
    required this.qrCode,
    required this.title,
    this.description,
    required this.vendor,
    required this.location,
    required this.validUntil,
    this.isRedeemed = false,
    this.isReuseable = false,
  });

  QrOffer copyWith({bool? isRedeemed, bool? isReuseable}) => QrOffer(
    qrCode: qrCode,
    title: title,
    description: description,
    vendor: vendor,
    location: location,
    validUntil: validUntil,
    isRedeemed: isRedeemed ?? this.isRedeemed,
    isReuseable: isReuseable ?? this.isReuseable,
  );
}
