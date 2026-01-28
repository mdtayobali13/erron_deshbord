class LiveStream {
  final String userName;
  final String userAvatar;
  final String streamTitle; // "Sarah Jenkins" (Name is bold)
  final String description; // "Sarah Streaming music live"
  final String thumbnail; // Asset path
  final bool isLive;
  final bool is4k;
  final bool isFree;
  final bool isFrozen;
  final int legitPercentage; // 98
  final int shadyPercentage; // 2
  final String streamId;
  final String? rawId;
  final int views;

  LiveStream({
    required this.userName,
    required this.userAvatar,
    required this.streamTitle,
    required this.description,
    required this.thumbnail,
    this.isLive = true,
    this.is4k = false,
    this.isFree = true,
    this.isFrozen = false,
    required this.legitPercentage,
    required this.streamId,
    this.rawId,
    this.views = 0,
  }) : shadyPercentage = 100 - legitPercentage;
}
