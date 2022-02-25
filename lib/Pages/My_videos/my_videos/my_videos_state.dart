
import 'package:video_aws/models/File.dart';

class MyVideosState {


  late List<File> items;

  MyVideosState({
      required items
  });

  MyVideosState copyWith({
    List<File>? items
  }) {
    return MyVideosState(
        items: items ?? this.items
    );
  }
}
