import 'dart:async';
import 'package:flutter/material.dart';
import '../models/overview_model.dart';
import '../models/live_stream_model.dart';
import '../models/stream_stats_model.dart';
import '../models/report_stats_model.dart';
import '../models/kyc_stats_model.dart';
import '../models/active_stream_model.dart';
import '../models/revenue_trend_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class OverviewViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<DashboardStat> _stats = [];
  List<DashboardStat> get stats => _stats;

  List<SalesData> _revenueTrend = [];
  List<SalesData> get revenueTrend => _revenueTrend;

  List<SalesData> _newUserTrend = [];
  List<SalesData> get newUserTrend => _newUserTrend;

  // Dashboard might also want to show a preview of live streams, so we can keep a small list here
  List<LiveStream> _previewStreams = [];
  List<LiveStream> get previewStreams => _previewStreams;

  Timer? _refreshTimer;

  OverviewViewModel() {
    loadData();
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      loadData(showLoading: false);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  int get totalViewers {
    int total = 0;
    for (var stream in _previewStreams) {
      total += stream.views;
    }
    return total;
  }

  Future<void> loadData({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final NetworkResponse response = await NetworkCaller.getRequest(
      AppUrls.activeStreams,
    );
    final NetworkResponse reportResponse = await NetworkCaller.getRequest(
      AppUrls.pendingReports,
    );

    final NetworkResponse kycResponse = await NetworkCaller.getRequest(
      AppUrls.pendingKyc,
    );
    final NetworkResponse activeStreamsResponse =
        await NetworkCaller.getRequest(AppUrls.activeStreamsList);

    StreamStatsModel? streamStats;
    if (response.isSuccess && response.responseData != null) {
      streamStats = StreamStatsModel.fromJson(response.responseData);
    }

    ReportStatsModel? reportStats;
    if (reportResponse.isSuccess && reportResponse.responseData != null) {
      reportStats = ReportStatsModel.fromJson(reportResponse.responseData);
    }

    KycStatsModel? kycStats;
    if (kycResponse.isSuccess && kycResponse.responseData != null) {
      kycStats = KycStatsModel.fromJson(kycResponse.responseData);
    }

    String totalRevenue = "0";

    // Revenue Trend API Call
    final NetworkResponse revenueResponse = await NetworkCaller.getRequest(
      "${AppUrls.revenueTrend}?year=$_selectedYear",
    );

    if (revenueResponse.isSuccess && revenueResponse.responseData != null) {
      final revenueData = RevenueTrendModel.fromJson(
        revenueResponse.responseData,
      );
      totalRevenue = revenueData.totalYearlyRevenue >= 1000
          ? "\$${(revenueData.totalYearlyRevenue / 1000).toStringAsFixed(1)}k"
          : "\$${revenueData.totalYearlyRevenue.toStringAsFixed(0)}";
      _revenueTrend = revenueData.monthlyRevenues.map((m) {
        return SalesData(m.month, m.revenueUsd);
      }).toList();
    } else {
      _revenueTrend = [];
    }

    _stats = [
      DashboardStat(
        title: "Total Active Streams",
        value: streamStats?.total.toString() ?? "0",
        subValue:
            "${streamStats?.free ?? 0} Free • ${streamStats?.paid ?? 0} Paid",
        badgeText: "+2.5%", // These could be dynamic too if API provides them
        badgeType: BadgeType.success,
        icon: Icons.videocam_outlined,
      ),
      DashboardStat(
        title: "Pending Reports",
        value: reportStats?.total.toString() ?? "0",
        subValue: "${reportStats?.highPriority ?? 0} High Priority",
        badgeText: "-1.2%",
        badgeType: BadgeType.error,
        icon: Icons.report_gmailerrorred_outlined,
      ),
      DashboardStat(
        title: "Total Token Sales",
        value: totalRevenue,
        subValue: "Year: $_selectedYear",
        badgeText: "+8.4%",
        badgeType: BadgeType.success,
        icon: Icons.monetization_on_outlined,
      ),
      DashboardStat(
        title: "Pending KYC Requests",
        value: kycStats?.total.toString() ?? "0",
        subValue: "${kycStats?.total ?? 0} Awaiting Review",
        badgeText: kycStats?.total == 0 ? "0%" : "+${kycStats?.total}",
        badgeType: BadgeType.success,
        icon: Icons.person_search_outlined,
      ),
    ];

    // Existing logic...

    final NetworkResponse userStatsResponse = await NetworkCaller.getRequest(
      "${AppUrls.userStatsMonthly}?year=$_selectedYear",
    );

    // ... existing parsing for other stats ...

    if (userStatsResponse.isSuccess && userStatsResponse.responseData != null) {
      final Map<String, dynamic> data = userStatsResponse.responseData;
      if (data['monthly_counts'] != null) {
        final List<dynamic> months = data['monthly_counts'];
        _newUserTrend = months.map((m) {
          return SalesData(
            m['month'].toString(),
            (m['count'] as num).toDouble(),
          );
        }).toList();
      }
    } else {
      _newUserTrend = [];
    }

    // Map API streams to UI model
    if (activeStreamsResponse.isSuccess &&
        activeStreamsResponse.responseData != null) {
      final List<dynamic> data = activeStreamsResponse.responseData;
      _previewStreams = data.where((json) => json['status'] != "ended").map((
        json,
      ) {
        final activeStream = ActiveStreamModel.fromJson(json);
        return LiveStream(
          userName:
              "${activeStream.host?.firstName ?? ""} ${activeStream.host?.lastName ?? ""}"
                  .trim(),
          userAvatar: activeStream.host?.profileImage ?? "",
          streamTitle: activeStream.title ?? "Untitled Stream",
          description: activeStream.category ?? "Live Stream",
          thumbnail: activeStream.thumbnail ?? "",
          legitPercentage: 100 - (activeStream.host?.shady ?? 0),
          streamId: "#${activeStream.id?.substring(0, 4) ?? "0000"}",
          rawId: activeStream.id,
          isFree: !(activeStream.isPremium ?? false),
          isFrozen: activeStream.isFrozen ?? false,
          views: activeStream.totalViews ?? 0,
        );
      }).toList();
    } else {
      _previewStreams = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  int _selectedYear = 2020;
  int get selectedYear => _selectedYear;

  void updateYear(int year) {
    _selectedYear = year;
    loadData(showLoading: false); // Refresh data with new year
  }

  void toggleStreamFreeze(String streamId, bool isCurrentlyFrozen) {
    final index = _previewStreams.indexWhere((s) => s.rawId == streamId);
    if (index != -1) {
      final current = _previewStreams[index];
      _previewStreams[index] = LiveStream(
        userName: current.userName,
        userAvatar: current.userAvatar,
        streamTitle: current.streamTitle,
        description: current.description,
        thumbnail: current.thumbnail,
        legitPercentage: current.legitPercentage,
        streamId: current.streamId,
        rawId: current.rawId,
        isFree: current.isFree,
        isFrozen: !isCurrentlyFrozen,
        isLive: current.isLive,
        is4k: current.is4k,
      );
      notifyListeners();
    }
  }
}
