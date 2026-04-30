class NotificationPreferenceModel {
  final String label;
  final String description;
  bool isEnabled;

  NotificationPreferenceModel({
    required this.label,
    required this.description,
    required this.isEnabled,
  });

  // Convert to API payload format
  Map<String, dynamic> toApiJson() {
    return {
      'newOffer': isEnabled && label == 'New Offers', // Adjust based on your mapping
      'renewalReminder': isEnabled && label == 'Renewal Reminders',
      'promotional': isEnabled && label == 'Promotions',
    };
  }

  // Better: Use separate model for API
  static Map<String, dynamic> buildApiPayload(List<NotificationPreferenceModel> prefs) {
    return {
      'newOffer': prefs.firstWhere((p) => p.label.contains('New Offers'), orElse: () => prefs[0]).isEnabled,
      'renewalReminder': prefs.firstWhere((p) => p.label.contains('Renewal Reminders'), orElse: () => prefs[1]).isEnabled,
      'promotional': prefs.firstWhere((p) => p.label.contains('Promotions'), orElse: () => prefs[2]).isEnabled,
    };
  }
}
