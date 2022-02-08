import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_repo.dart';
import 'my_videos_event.dart';
import 'my_videos_state.dart';


class MyVideosBloc extends Bloc<MyVideosEvent, MyVideosState>{

  DataRepo dataRepo;
  String category = "";

  MyVideosBloc({required this.dataRepo, required this.category}) : super(MyVideosState(videos: [], grados: [], videosNames: [], categories: [])){
    on<DeleteVideoButtonClickedEvent>(_onDeleteVideoButtonClickedEvent);
    on<GetMyVideosEvent>(_getMyVideos);

    on<CategoryClickedMyVideosEvent>(_getVideosInACategoryMyVideos);
    on<GetMyVideosEventGRADO>(_getMyVideoEventGRADO);
  }

  FutureOr<void> _onDeleteVideoButtonClickedEvent(DeleteVideoButtonClickedEvent event,
      Emitter<MyVideosState> emit) async {

      List<String> videos = await dataRepo.getMyVideos(category);

      await dataRepo.deleteVideo(category, videos[event.index]);

      await dataRepo.listItems();

      videos = await dataRepo.getMyVideosForUI(category);

      emit(state.copyWith(totalVideos: videos.length, videos: videos));
  }

  FutureOr<void> _getMyVideos(GetMyVideosEvent event, Emitter<MyVideosState> emit) async {
    List<String> videos = await dataRepo.getMyVideosForUI(category);

    emit(state.copyWith(totalVideos: videos.length, videos: videos));
  }

  FutureOr<void> _getVideosInACategoryMyVideos(CategoryClickedMyVideosEvent event, Emitter<MyVideosState> emit) {
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

  FutureOr<void> _getMyVideoEventGRADO(GetMyVideosEventGRADO event, Emitter<MyVideosState> emit) async {
    List<String> grados = await dataRepo.getVideosGrado(category);
    emit(state.copyWith(totalGrados: grados.length, grados: grados, ));
  }

}

