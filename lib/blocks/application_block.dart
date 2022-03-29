import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:property_valuation/models/geometry.dart';
import 'package:property_valuation/models/place.dart';
import 'package:property_valuation/models/places_search.dart';
import 'package:property_valuation/services/geolocator_service.dart';
import 'package:property_valuation/services/marker_service.dart';
import 'package:property_valuation/services/places_service.dart';
import 'package:property_valuation/models/location.dart';
import 'package:property_valuation/ui/dashboard.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();


  List<PlaceSearch> searchResults=[];
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  Place selectedLocationStatic=Place(name: '', geometry:Geometry(location: Location(
      lat: lat!.toDouble(), lng: lon!.toDouble()), ), vicinity: '');
  List<Place> placeResults=[];
  List<Marker> markers = [];


  ApplicationBloc();


  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }


  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = [];
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocationStatic;
    searchResults = [];
    notifyListeners();
  }

  togglePlaceType() async {
    var places = await placesService.getPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng);
      if (places.isNotEmpty) {
        var newMarker = markerService.createMarkerFromPlace(places[0],false);
        markers.add(newMarker);
      }
      var locationMarker = markerService.createMarkerFromPlace(selectedLocationStatic,true);
      markers.add(locationMarker);
      var _bounds = markerService.bounds(Set<Marker>.of(markers));
      bounds.add(_bounds!);
      notifyListeners();
  }



  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }}