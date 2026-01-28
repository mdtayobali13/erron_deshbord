class StreamStatsModel {
  final int total;
  final int free;
  final int paid;

  StreamStatsModel({
    required this.total,
    required this.free,
    required this.paid,
  });

  factory StreamStatsModel.fromJson(Map<String, dynamic> json) {
    return StreamStatsModel(
      total: json['total'] ?? 0,
      free: json['free'] ?? 0,
      paid: json['paid'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'free': free, 'paid': paid};
  }
}
