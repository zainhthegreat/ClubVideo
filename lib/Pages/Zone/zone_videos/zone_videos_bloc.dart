import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_repo.dart';
import 'zone_videos_event.dart';
import 'zone_videos_state.dart';

class ZoneVideosBloc extends Bloc<ZoneVideosEvent, ZoneVideosState>{

  DataRepo dataRepo;
  String category = "";


  ZoneVideosBloc({required this.dataRepo, required this.category,}) : super(ZoneVideosState(categories: [], videos: [], videosNames: [], grados: [])){

    on<DeleteVideoZoneButtonClickedEvent>(_onDeleteVideoButtonClickedEvent);
    on<CategoryClickedZoneVideosEvent>(_getVideosInACategoryZoneVideo);
    on<GetZoneVideosEvent>(_getZoneVideos);
    on<GetZoneVideosEventGRADO>(_getVideoZoneGRADO);
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

}