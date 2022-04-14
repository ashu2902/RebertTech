class PlaceSearch{
  late final String placeId;
  late final String description;

  PlaceSearch(this.placeId, this.description);
  factory PlaceSearch.fromJson(Map<String, dynamic> json){
    return PlaceSearch(
        json['place_id'],
        json['description']
    );
  }
}