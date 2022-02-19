import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_aws/Pages/Upload/upload_video/upload_videos_event.dart';
import 'package:video_aws/Pages/Upload/upload_video/upload_videos_state.dart';

import '../../../amplifyconfiguration.dart';
import '../../../data_repo.dart';




class UploadVideoBloc extends Bloc<UploadVideoEvent, UploadVideoState> {
  late FilePickerResult? _result;
  DataRepo dataRepo;
  String category = "";

  late FilePickerResult? _imageresult;



  UploadVideoBloc({required this.dataRepo}) : super(UploadVideoState()) {
    on<FilePickerUploadVideoButtonClickedEvent>(_filePickerButtonClicked);  ///video

    on<VideoSelectedUploadEvent>(
        (event, emit) => emit(state.copyWith(video: event.video, image: event.image)));


    on<ImageFilePickerUploadVideoButtonClickedEvent>(_ImagefilePickerButtonClicked);   ///Image

    on<ImageSelectedUploadEvent>(
            (event, emit) => emit(state.copyWith(image: event.image)));



    on<UploadVideoButtonClickedEvent>(_uploadFile);


  }

  get image => null;


  ///video
  FutureOr<void> _filePickerButtonClicked(FilePickerUploadVideoButtonClickedEvent event,
      Emitter<UploadVideoState> emit) async {
    _result = await FilePicker.platform.pickFiles(
      type: FileType.video,

    );
  }

  ///image
  FutureOr<void> _ImagefilePickerButtonClicked(ImageFilePickerUploadVideoButtonClickedEvent event,
      Emitter<UploadVideoState> emit) async {
    _imageresult = await FilePicker.platform.pickFiles(type: FileType.image, onFileLoading: image);


  }


  FutureOr<void> _uploadFile(UploadVideoButtonClickedEvent event,
      Emitter<UploadVideoState> emit) async {
    //TODO add category to the UI through navigation and access using event
     String ret = await dataRepo.uploadVideo(_result, category, event.fileName,event.desc, event.grado);
     await dataRepo.uploadImage(_imageresult, category, event.fileName,event.desc, event.grado);
      if(ret == 'Uploaded Successfully') {
        emit(state.copyWith(uploaded: true));
      }
  }
}
