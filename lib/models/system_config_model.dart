class SystemConfig {
  final String? id;
  final bool? enableRegistration;
  final bool? enablePaidStreams;
  final bool? enableGifting;
  final DateTime? updatedAt;

  SystemConfig({
    this.id,
    this.enableRegistration,
    this.enablePaidStreams,
    this.enableGifting,
    this.updatedAt,
  });

  factory SystemConfig.fromJson(Map<String, dynamic> json) {
    return SystemConfig(
      id: json['id'],
      enableRegistration: json['enable_registration'],
      enablePaidStreams: json['enable_paid_streams'],
      enableGifting: json['enable_gifting'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enable_registration': enableRegistration,
      'enable_paid_streams': enablePaidStreams,
      'enable_gifting': enableGifting,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
