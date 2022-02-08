abstract class ZoneVideosEvent {}

class GetZoneVideosEvent extends ZoneVideosEvent{}

class CategoryClickedZoneVideosEvent extends ZoneVideosEvent {
  int categoryIndex;
  CategoryClickedZoneVideosEvent({required this.categoryIndex});
}

class DeleteVideoZoneButtonClickedEvent extends ZoneVideosEvent{
  int index;
  DeleteVideoZoneButtonClickedEvent({required this.index});
}

class SearchEvent extends ZoneVideosEvent{
  String searchedKeyword;
  SearchEvent({required this.searchedKeyword});
}

class GetZoneVideosEventGRADO extends ZoneVideosEvent{}

