import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_aws/Pages/Zone/zone_menu/zone_menu_event.dart';
import 'package:video_aws/Pages/Zone/zone_menu/zone_menu_state.dart';

import '../../../data_repo.dart';

class ZoneMenuBloc extends Bloc<ZoneMenuEvent, ZoneMenuState>{

  DataRepo dataRepo;

  ZoneMenuBloc({required this.dataRepo}) : super(ZoneMenuState(categories: [], videos: [], videosNames: [])){

    on<CategoryClickedZoneMenuEvent>(_getVideosInACategoryZoneMenu);
    on<GetCategoriesZoneMenuEvent>(_getCategoriesZoneMenu);
    on<RefreshListsZoneMenuEvent>(_refreshListsZoneMenu);
    on<SearchEventZoneMenu>(_searchVideosZoneMenu);
  }


  _getCategoriesZoneMenu(GetCategoriesZoneMenuEvent event, Emitter<ZoneMenuState> emit) async {

    List<String> categories = await dataRepo.getCategoriesSectoresMenu();
    emit(state.copyWith(totalCategories: categories.length, categories: categories));
  }

  FutureOr<void> _getVideosInACategoryZoneMenu(CategoryClickedZoneMenuEvent event, Emitter<ZoneMenuState> emit) {

    emit(state.copyWith(currentCategory: event.categoryIndex));
    if(event.categoryIndex != -1) {

      String categoryName = state.categories[state.currentCategory];

      List<String> tempVideos = dataRepo.getVideoForUISectoresMenu(categoryName);
      List<String> videos = [];
      String keyword = state.searchedKeyword;
      for(int i = 0; i < tempVideos.length; i++){
        if(tempVideos[i].contains(keyword)){
          videos.add(tempVideos[i]);
        }
      }

      List<String> tempVideosNames = dataRepo.getVideoNamesSectoresMenu(categoryName);
      List<String> videosNames = [];

      for(int i = 0; i < tempVideosNames.length; i++){
        if(tempVideosNames[i].contains(keyword)){
          videosNames.add(tempVideosNames[i]);
        }
      }

      if(keyword.isNotEmpty) {
        emit(state.copyWith(totalVideosInCurrentCategory: videos.length));
        emit(state.copyWith(videos: videos, videosNames: videosNames));
      }
      else{
        emit(state.copyWith(totalVideosInCurrentCategory: tempVideos.length));
        emit(state.copyWith(videos: tempVideos, videosNames: tempVideosNames));
      }
    }
  }

  FutureOr<void> _refreshListsZoneMenu(RefreshListsZoneMenuEvent event, Emitter<ZoneMenuState> emit) async {
    await dataRepo.listItemsSectoresMenu();

    List<String> categories = await dataRepo.getCategoriesSectoresMenu();

    emit(state.copyWith(totalCategories: categories.length, categories: categories, currentCategory: -1));
  }

  FutureOr<void> _searchVideosZoneMenu(SearchEventZoneMenu event, Emitter<ZoneMenuState> emit) {
    emit(state.copyWith(searchedKeyword: event.searchedKeyword));
  }
}







