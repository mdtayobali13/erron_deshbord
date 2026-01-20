import 'package:flutter/material.dart';
import '../models/live_stream_model.dart';

class LiveMonitorViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<LiveStream> _liveStreams = [];
  List<LiveStream> get liveStreams => _liveStreams;

  LiveMonitorViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _liveStreams = [
      LiveStream(
        userName: "Sarah Jenkins",
        userAvatar: "https://randomuser.me/api/portraits/women/44.jpg",
        streamTitle: "Sarah Jenkins",
        description: "Sarah Streaming music live",
        thumbnail:
            "https://images.unsplash.com/photo-1516280440614-6697288d5d38?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        legitPercentage: 98,
        streamId: "#4521",
      ),
      LiveStream(
        userName: "Isabell Reide",
        userAvatar: "https://randomuser.me/api/portraits/women/65.jpg",
        streamTitle: "Isabell Reide",
        description: "Sea beach touring",
        thumbnail:
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        legitPercentage: 92,
        streamId: "#8832",
      ),
      LiveStream(
        userName: "Arthur Doe",
        userAvatar: "https://randomuser.me/api/portraits/men/32.jpg",
        streamTitle: "Arthur Doe",
        description: "Urban Photography",
        thumbnail:
            "https://images.unsplash.com/photo-1554048612-387768052bf7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        legitPercentage: 95,
        streamId: "#9941",
      ),
      // Adding duplicates to test pagination/grid
      LiveStream(
        userName: "Sarah Jenkins",
        userAvatar: "https://randomuser.me/api/portraits/women/44.jpg",
        streamTitle: "Sarah Jenkins",
        description: "Sarah Streaming music live",
        thumbnail:
            "https://images.unsplash.com/photo-1516280440614-6697288d5d38?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        legitPercentage: 98,
        streamId: "#4522",
      ),
      LiveStream(
        userName: "Isabell Reide",
        userAvatar: "https://randomuser.me/api/portraits/women/65.jpg",
        streamTitle: "Isabell Reide",
        description: "Sea beach touring",
        thumbnail:
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        legitPercentage: 92,
        streamId: "#8833",
      ),
      LiveStream(
        userName: "Arthur Doe",
        userAvatar: "https://randomuser.me/api/portraits/men/32.jpg",
        streamTitle: "Arthur Doe",
        description: "Urban Photography",
        thumbnail:
            "https://images.unsplash.com/photo-1554048612-387768052bf7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        legitPercentage: 95,
        streamId: "#9942",
      ),
      LiveStream(
        userName: "Sarah Jenkins",
        userAvatar: "https://randomuser.me/api/portraits/women/44.jpg",
        streamTitle: "Sarah Jenkins",
        description: "Sarah Streaming music live",
        thumbnail:
            "https://images.unsplash.com/photo-1516280440614-6697288d5d38?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        legitPercentage: 98,
        streamId: "#4523",
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
