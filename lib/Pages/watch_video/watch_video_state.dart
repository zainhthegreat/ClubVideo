class WatchVideosState{
  String name;
  String url;
  String UIName;

  WatchVideosState({
    required this.name,
    this.url = '',
    required this.UIName,
  });

  WatchVideosState copyWith({
    String? name,
    String? url,
    String? UIName,
  }) {
    return WatchVideosState(
      name: name?? this.name,
      url: url?? this.url,
      UIName: UIName?? this.UIName,
    );
  }
}