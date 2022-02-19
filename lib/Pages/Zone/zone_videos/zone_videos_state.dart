import 'package:video_aws/Pages/Zone/zone_videos/zone_videos_event.dart';

enum SearchBy { name, grado }

class ZoneVideosState {
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
  List<String> searchedVideos;
  List<String> searchedVideosGrados;

  bool isSearching;
  SearchBy searchBy;

  ZoneVideosState({
    this.isSearching = false,
    this.totalVideos = 0,
    required this.videos,
    this.totalGrados = 0,
    required this.grados,
    this.totalCategories = 0,
    this.currentCategory = -1,
    this.totalVideosInCurrentCategory = 0,
    required this.categories,
    required this.videosNames,
    required this.searchedVideos,
    required this.searchedVideosGrados,
    this.searchedKeyword = '',
    this.searchBy = SearchBy.name,
  });

  ZoneVideosState copyWith({
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
    bool? isSearching,
    List<String>? searchedVideos,
    List<String>? searchedVideosGrados,
    SearchBy? searchBy,
  }) {
    return ZoneVideosState(
      totalVideos: totalVideos ?? this.totalVideos,
      videos: videos ?? this.videos,
      totalGrados: totalGrados ?? this.totalGrados,
      grados: grados ?? this.grados,
      totalCategories: totalCategories ?? this.totalCategories,
      currentCategory: currentCategory ?? this.currentCategory,
      totalVideosInCurrentCategory:
          totalVideosInCurrentCategory ?? this.totalVideosInCurrentCategory,
      categories: categories ?? this.categories,
      videosNames: videosNames ?? this.videosNames,
      searchedKeyword: searchedKeyword ?? this.searchedKeyword,
      isSearching: isSearching ?? this.isSearching,
      searchedVideos: searchedVideos ?? this.searchedVideos,
      searchedVideosGrados: searchedVideosGrados ?? this.searchedVideosGrados,

        searchBy: searchBy?? this.searchBy,
    );
  }
}
