import 'dart:async';
import 'package:flutter/material.dart';
import '../models/live_stream_model.dart';
import '../models/stream_stats_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';

class LiveMonitorViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<LiveStream> _liveStreams = [];
  List<LiveStream> get liveStreams => _liveStreams;

  bool _isAiAutoModerationEnabled = false;
  bool get isAiAutoModerationEnabled => _isAiAutoModerationEnabled;

  StreamStatsModel? _streamStats;
  StreamStatsModel? get streamStats => _streamStats;

  int get totalViewers {
    int total = 0;
    for (var stream in _liveStreams) {
      total += stream.views;
    }
    return total;
  }

  Timer? _refreshTimer;

  // Persistent lock to ensure manual admin actions are not overwritten by slow API refreshes
  final Map<String, bool> _manualFrozenLock = {};

  void toggleAiAutoModeration() {
    _isAiAutoModerationEnabled = !_isAiAutoModerationEnabled;
    notifyListeners();
  }

  LiveMonitorViewModel() {
    loadData();
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      loadData(showLoading: false);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> loadData({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final NetworkResponse response = await NetworkCaller.getRequest(
      AppUrls.activeStreams,
    );
    final NetworkResponse activeListResponse = await NetworkCaller.getRequest(
      AppUrls.activeStreamsList,
    );

    if (response.isSuccess && response.responseData != null) {
      _streamStats = StreamStatsModel.fromJson(response.responseData);
    }

    if (activeListResponse.isSuccess &&
        activeListResponse.responseData != null) {
      final List<dynamic> data = activeListResponse.responseData;
      _liveStreams = data
          .where((json) => json['status']?.toString().toLowerCase() != "ended")
          .map((json) {
            final id = json['id']?.toString() ?? "";
            final host = json['host'] ?? {};
            final firstName = host['first_name'] ?? "";
            final lastName = host['last_name'] ?? "";
            final shady = host['shady'] ?? 0;

            bool apiIsFrozen = json['is_frozen'] ?? false;

            // ADMIN INTENT PROTECTION:
            // Use the lock value if it exists, otherwise use API value.
            // We only clear the lock when the API matches our local intent.
            bool finalIsFrozen = apiIsFrozen;
            if (_manualFrozenLock.containsKey(id)) {
              finalIsFrozen = _manualFrozenLock[id]!;
              if (apiIsFrozen == _manualFrozenLock[id]) {
                _manualFrozenLock.remove(id);
                debugPrint("API Synced for Stream $id. Lock released.");
              }
            }

            return LiveStream(
              userName: "$firstName $lastName".trim(),
              userAvatar: host['profile_image'] ?? "",
              streamTitle: json['title'] ?? "Untitled",
              description: json['category'] ?? "Live",
              thumbnail: json['thumbnail'] ?? "",
              legitPercentage: 100 - (shady as int),
              streamId: "#${id.length > 4 ? id.substring(0, 4) : id}",
              rawId: id,
              isFree: !(json['is_premium'] ?? false),
              isFrozen: finalIsFrozen,
              views: json['total_views'] ?? 0,
            );
          })
          .toList();
    } else {
      _liveStreams = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleFreezeStream(String streamId) async {
    final String url = AppUrls.resumeStream;

    final index = _liveStreams.indexWhere((s) => s.rawId == streamId);
    if (index != -1) {
      final currentStream = _liveStreams[index];
      final bool targetState = !currentStream.isFrozen;

      // 1. Instantly Lock the state to prevent timer rollback
      _manualFrozenLock[streamId] = targetState;

      // 2. Update local UI state
      _liveStreams[index] = LiveStream(
        userName: currentStream.userName,
        userAvatar: currentStream.userAvatar,
        streamTitle: currentStream.streamTitle,
        description: currentStream.description,
        thumbnail: currentStream.thumbnail,
        legitPercentage: currentStream.legitPercentage,
        streamId: currentStream.streamId,
        rawId: currentStream.rawId,
        isFree: currentStream.isFree,
        isFrozen: targetState,
        isLive: currentStream.isLive,
        is4k: currentStream.is4k,
      );
      notifyListeners();
    }

    final String finalUrl = "$url/$streamId";
    debugPrint("Final Resume/Freeze URL: $finalUrl");
    
    final response = await NetworkCaller.putRequest(finalUrl);
    debugPrint(
      "Final Resume/Freeze Response: ${response.statusCode} - ${response.responseData} - ${response.errorMessage}",
    );

    if (response.isSuccess) {
      await loadData(showLoading: false);
      return true;
    } else {
      _manualFrozenLock.remove(streamId);
      await loadData();
      return false;
    }
  }

  Future<bool> stopStream(String streamId) async {
    debugPrint("Attempting to stop stream (Optimistic UI): $streamId");
    final backup = List<LiveStream>.from(_liveStreams);
    _liveStreams.removeWhere((s) => s.rawId == streamId);
    notifyListeners();
    debugPrint("URL: ${AppUrls.stopStream}/$streamId");
    final response = await NetworkCaller.postRequest(
      "${AppUrls.stopStream}/$streamId",
      body: {}, 
    );

    debugPrint(
      "Stop Response: ${response.statusCode} - ${response.responseData} - ${response.errorMessage}",
    );

    if (response.isSuccess) {
      debugPrint("Stream $streamId Stopped Successfully on server");
      await loadData();
      return true;
    } else {
      debugPrint("Failed to stop on server. Rolling back local state.");
      _liveStreams = backup;
      notifyListeners();
      return false;
    }
  }
}
