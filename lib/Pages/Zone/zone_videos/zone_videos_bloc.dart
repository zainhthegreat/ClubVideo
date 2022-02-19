import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_repo.dart';
import 'zone_videos_event.dart';
import 'zone_videos_state.dart';

class ZoneVideosBloc extends Bloc<ZoneVideosEvent, ZoneVideosState>{

  DataRepo dataRepo;
  String category = "";


  ZoneVideosBloc({required this.dataRepo, required this.category,}) : super(ZoneVideosState(
      categories: [], videos: [], videosNames: [], grados: [],
      searchedVideos: [], searchedVideosGrados: [])){

    on<DeleteVideoZoneButtonClickedEvent>(_onDeleteVideoButtonClickedEvent);
    on<CategoryClickedZoneVideosEvent>(_getVideosInACategoryZoneVideo);
    on<GetZoneVideosEvent>(_getZoneVideos);
    on<GetZoneVideosEventGRADO>(_getVideoZoneGRADO);
    on<ToggleSearching>(_toggleSearching);
    on<SearchKeywordChanged>(_searchKeywordChanged);
    on<Search>(_search);
    on<SearchByEvent>(_searchByChanged);
  }


  FutureOr<void> _onDeleteVideoButtonClickedEvent(DeleteVideoZoneButtonClickedEvent event,
      Emitter<ZoneVideosState> emit) async {

      List<String> videos = await dataRepo.getSectorVideos(category);

      await dataRepo.deleteVideo(category, videos[event.index]);
      await dataRepo.listItemsSectoresVideos();

      videos = await dataRepo.getSectorVideosForUI(category);
      emit(state.copyWith(totalVideos: videos.length, videos: videos, ));
  }

  FutureOr<void> _getVideosInACategoryZoneVideo(CategoryClickedZoneVideosEvent event, Emitter<ZoneVideosState> emit) {

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

  FutureOr<void> _getZoneVideos(GetZoneVideosEvent event, Emitter<ZoneVideosState> emit) async {
    List<String> videos = await dataRepo.getSectorVideosForUI(category);
    emit(state.copyWith(totalVideos: videos.length, videos: videos, ));
  }

  FutureOr<void> _getVideoZoneGRADO(GetZoneVideosEventGRADO event, Emitter<ZoneVideosState> emit) async {
    List<String> grados = await dataRepo.getVideosGrado(category);
    emit(state.copyWith(totalGrados: grados.length, grados: grados, ));
  }


  FutureOr<void> _toggleSearching(ToggleSearching event, Emitter<ZoneVideosState> emit) {
    if(state.isSearching){
      emit(state.copyWith(isSearching: false));
    }
    else{
      emit(state.copyWith(isSearching: true));
    }
  }

  FutureOr<void> _searchKeywordChanged(SearchKeywordChanged event, Emitter<ZoneVideosState> emit) {
    emit(state.copyWith(searchedKeyword: event.value));
  }



  FutureOr<void> _search(Search event, Emitter<ZoneVideosState> emit) {

    List<String> searchedVideos = [];
    List<String> searchedVideosGrados = [];

    if(state.searchBy == SearchBy.name) {

      for (int i = 0; i < state.videos.length; i++) {
        if (state.videos[i].contains(state.searchedKeyword)) {
          searchedVideos.add(state.videos[i]);
          searchedVideosGrados.add(state.grados[i]);
        }
      }
    }
    else  if(state.searchBy == SearchBy.grado){
      for (int i = 0; i < state.videos.length; i++) {
        if (state.grados[i] == event.grado) {
          searchedVideos.add(state.videos[i]);
          searchedVideosGrados.add(state.grados[i]);
        }
      }
    }

    emit(state.copyWith(searchedVideos: searchedVideos));
    emit(state.copyWith(searchedVideosGrados: searchedVideosGrados));
  }

  FutureOr<void> _searchByChanged(SearchByEvent event, Emitter<ZoneVideosState> emit) {
    emit(state.copyWith(searchBy: event.searchBy));
  }
}