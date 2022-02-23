import 'package:video_aws/auth/form_submission_state.dart';

class ZoneMenuState {
  int totalCategories;
  int currentCategory;
  int totalVideosInCurrentCategory;
  List<String> categories;
  List<String> videos;
  List<String> videosNames;
  String searchedKeyword;
  FormSubmissionState formSubmissionState;

  ZoneMenuState({
    this.totalCategories = 0,
    this.currentCategory = -1,
    this.totalVideosInCurrentCategory = 0,
    this.searchedKeyword = '',
    required this.categories,
    required this.videos,
    required this.videosNames,
    this.formSubmissionState = const InitialFormState(),
  });

  ZoneMenuState copyWith({
    int? totalCategories,
    int? currentCategory,
    int? totalVideosInCurrentCategory,
    List<String>? categories,
    List<String>? videos,
    List<String>? videosNames,
    String? searchedKeyword,
    FormSubmissionState? formSubmissionState,
  }) {
    return ZoneMenuState(
      totalCategories: totalCategories ?? this.totalCategories,
      currentCategory: currentCategory ?? this.currentCategory,
      totalVideosInCurrentCategory:
          totalVideosInCurrentCategory ?? this.totalVideosInCurrentCategory,
      categories: categories ?? this.categories,
      videos: videos ?? this.videos,
      videosNames: videosNames ?? this.videosNames,
      searchedKeyword: searchedKeyword ?? this.searchedKeyword,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
