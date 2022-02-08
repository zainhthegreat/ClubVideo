abstract class MyVideosEvent {}

class GetMyVideosEvent extends MyVideosEvent{}

class DeleteVideoButtonClickedEvent extends MyVideosEvent{
  int index;

  DeleteVideoButtonClickedEvent({required this.index});
}


class CategoryClickedMyVideosEvent extends MyVideosEvent {
  int categoryIndex;

  CategoryClickedMyVideosEvent({required this.categoryIndex});
}

class GetMyVideosEventGRADO extends MyVideosEvent{}

