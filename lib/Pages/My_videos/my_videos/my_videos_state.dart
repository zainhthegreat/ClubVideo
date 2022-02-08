
class MyVideosState {
  int totalVideos;
  List<String> videos;

  int totalGrados;
  List<String> grados;

  int totalCategories;
  int currentCategory;
  int totalVideosInCurrentCategory;
  List<String> categories;
  List<String> videosNames;

  String searchedKeyword;

  MyVideosState({
    this.totalVideos = 0,
    required this.videos,
    this.totalGrados = 0,
    required this.grados,
    this.totalCategories = 0,
    this.currentCategory = -1,
    this.totalVideosInCurrentCategory = 0,
    required this.categories,
    required this.videosNames,

    this.searchedKeyword = '',
  });

  MyVideosState copyWith({
    int? totalVideos,
    List<String>? videos,
    int? totalGrados,
    List<String>? grados,
    int? totalCategories,
    int? currentCategory,
    int? totalVideosInCurrentCategory,
    List<String>? categories,
    List<String>? videosNames,

    String? searchedKeyword,

  }) {
    return MyVideosState(
      totalVideos: totalVideos ?? this.totalVideos,
      videos: videos?? this.videos,
      totalGrados: totalGrados?? this.totalGrados,
      grados: grados?? this.grados,
      totalCategories: totalCategories ?? this.totalCategories,
      currentCategory: currentCategory ?? this.currentCategory,
      totalVideosInCurrentCategory:
      totalVideosInCurrentCategory ?? this.totalVideosInCurrentCategory,
      categories: categories?? this.categories,
      videosNames: videosNames?? this.videosNames,

      searchedKeyword: searchedKeyword?? this.searchedKeyword,

    );
  }
}
