class ReportStatsModel {
  final int total;
  final int highPriority;

  ReportStatsModel({required this.total, required this.highPriority});

  factory ReportStatsModel.fromJson(Map<String, dynamic> json) {
    return ReportStatsModel(
      total: json['total'] ?? 0,
      highPriority: json['high_priority'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'high_priority': highPriority};
  }
}
