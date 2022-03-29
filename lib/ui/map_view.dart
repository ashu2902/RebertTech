import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:property_valuation/blocks/application_block.dart';
import 'package:property_valuation/models/place.dart';
import 'package:property_valuation/ui/create_case.dart';
import 'package:provider/provider.dart';
import 'dashboard.dart';
import 'sale_comparable.dart';
class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;
  late StreamSubscription boundsSubscription;
  final _locationController = TextEditingController();
  final List<Marker> _markers=[];
  @override
  void initState() {
    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);
    //Listen for selected Location
    locationSubscription = applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name;
        _goToPlace(place);
      } else
        _locationController.text = "";
    });

    applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return SafeArea(
      child: Scaffold(
          body: ListView(
              physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _locationController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => applicationBloc.searchPlaces(value),
                  onTap: () {
                    applicationBloc.clearSelectedLocation();

                  },
                ),
              ),
              SizedBox(
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      location=applicationBloc.selectedLocationStatic.geometry.location.lat.toString()+applicationBloc.selectedLocationStatic.geometry.location.lng.toString();
                      lati = applicationBloc.selectedLocationStatic.geometry.location.lat.toString();
                      longi = applicationBloc.selectedLocationStatic.geometry.location.lng.toString();
                      salelocationcontroller=TextEditingController(text: location);
                      address=applicationBloc.selectedLocationStatic.name;
                      vicinity = applicationBloc.selectedLocationStatic.vicinity;
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SaleComparable()));
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Done'),
                ),
              ),
              Stack(
                children: [

                  Container(
                    height: 700.0,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            lat!,
                            lon!),
                        zoom: 14,
                      ),
                      buildingsEnabled: true,
                      zoomControlsEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                      markers: _markers.toSet(),
                      onTap: (position){
                        _handleTap(LatLng(position.latitude, position.longitude));
                        setState(() {
                          latitude=position.latitude.toString();
                          longitude=position.longitude.toString();
                          print(latitude+longitude);
                          location=latitude+longitude;
                        });


                      },
                    ),
                  ),
                  if (applicationBloc.searchResults.isNotEmpty)
                    Container(
                        height: 300.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.6),
                            backgroundBlendMode: BlendMode.darken,
                        ),
                    ),
                    SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: applicationBloc.searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                applicationBloc
                                    .searchResults[index].description,
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () async {
                                applicationBloc.setSelectedLocation(
                                    applicationBloc
                                        .searchResults[index].placeId);
                                applicationBloc.togglePlaceType();
                                _goToPlace(applicationBloc.selectedLocationStatic);

                              },
                            );
                          }),
                    ),
                ],
              ),

            ],
          )),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 16.0
        ),
      ),
    );
  }
  _handleTap(LatLng point) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: const InfoWindow(
          title: ''
        ),
        icon:
        BitmapDescriptor.defaultMarker,
       ),
      );
    });
  }
}
