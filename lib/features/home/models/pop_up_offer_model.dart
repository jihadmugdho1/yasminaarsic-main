class PopupOfferModel {
  final String title;
  final String description;
  final String actionLabel;
  final String trialDuration;
  final String iconPath; // Use asset path or a built-in icon

  PopupOfferModel({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.trialDuration,
    required this.iconPath,
  });
}
