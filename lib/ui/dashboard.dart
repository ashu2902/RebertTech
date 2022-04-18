import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:property_valuation/ui/side_navbar.dart';
import 'package:property_valuation/ui/visit_detail.dart';

import '../main.dart';
import 'case_item.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

double? lat, lon;
List latitudes = [];
List longitudes = [];

class _DashboardState extends State<Dashboard> {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;
  Completer<GoogleMapController> _controller = Completer();

  Iterable markers = [];

  final Iterable _markers = Iterable.generate(latitudes.length, (index) {
    return Marker(
        markerId: MarkerId(AppConstant.list[index]['id']),
        position: LatLng(
          latitudes[index],
          longitudes[index],
        ),
        infoWindow: InfoWindow(title: AppConstant.list[index]["title"]));
  });
  DocumentReference userReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  late String bank = '';
  late String id = '';
  var borrowerNames = {};
  late String customerName = '', fullname = '', title = '';
  late String propertyType = '';
  late String visitDate = '';
  late String customerPhone = '',
      latitude = '',
      loanAcNo = '',
      longitude = '',
      purposeOfValuation = '';
  late String siteAddress = '',
      bankBranchName = '',
      bankEmployeeName = '',
      instructions = '',
      jobBranch = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
  late GoogleMapController _googleMapController;
  late String location = '';
  late GoogleMapController controller;
  Future<void> _signOut() async {
    await _auth.signOut();
  }

  List lists = [];
  List eachList = [];
  List caseIdList = [];

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    super.initState();
    _toggleServiceStatusStream();
    _getCurrentPosition();
  }

  Future<void> getProfile() async {
    CollectionReference docRef =
        FirebaseFirestore.instance.collection('assigned_cases');
    QuerySnapshot snapshot = await docRef.get();
    final messages = snapshot.docs;
    setState(() {});
    for (var message in messages) {
      if (message.get('valuer') == userReference) {
        DocumentReference caseReference = message.get('caseId');
        lists.add(caseReference);
        print(caseReference.get());
      }
      print(message.get('valuer'));
    }
    CollectionReference reference =
        FirebaseFirestore.instance.collection('Cases');
    QuerySnapshot snapshot1 = await reference.get();
    final messages1 = snapshot1.docs;
    for (var message in messages1) {
      if (lists.contains(message.reference) &&
          (message.get('caseStatus') == 'Assigned to Valuer' ||
              message.get('caseStatus') == 'Partially Done' ||
              message.get('caseStatus') == 'Visit Postponed')) {
        eachList.add(message.data());

        caseIdList.add(message.reference.id);
      }
    }
    print("This is eachList ${eachList[1]["dateOfInspection"]}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            content: const Text(
              "Do you wish to Exit or Logout?",
              style: TextStyle(color: Colors.black, fontFamily: "BonaNova"),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    "Exit",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "BonaNova"),
                  )),
              FlatButton(
                  onPressed: () {
                    _signOut();
                    Navigator.of(ctx).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(
                          title: 'Property Evaluation',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Logout",
                    style:
                        TextStyle(color: Colors.black, fontFamily: "BonaNova"),
                  ))
            ],
          ),
        );
        // You can do some work here.
        // Returning true allows the pop to happen, returning false prevents it.
        // I understand none of this shit.
        return true;
      },
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          drawer: SideBar(),
          appBar: AppBar(
            centerTitle: true,
            title: Text('Property Evaluation'),
            flexibleSpace: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            bottom: const TabBar(
              //isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: [
                Tab(
                  icon: Icon(Icons.list_alt_outlined),
                  text: 'List View',
                ),
              ],
            ),
            elevation: 20,
            titleSpacing: 20,
          ),
          body: TabBarView(
            children: [
              Container(
                child: ListView.builder(
                    itemCount: eachList.length,
                    itemBuilder: (context, index) {
                      List contacts = ['', ''];
                      List names = [];
                      List titles = [];
                      names.clear();
                      customerName = '';
                      names = eachList[index]['borrowerNames'];
                      for (int i = 0; i < names.length; i++) {
                        customerName = customerName +
                            names[i]['title'] +
                            ' ' +
                            names[i]['fullName'] +
                            ', ';
                      }
                      names.clear();
                      contacts = eachList[index]['contactNo'];
                      Timestamp timestamp =
                          eachList[index]['dateOfInspection'] == ""
                              ? Timestamp(0, 0)
                              : eachList[index]['dateOfInspection'];
                      DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
                          timestamp.microsecondsSinceEpoch);
                      String dateOfInspection = dateTime.day.toString() +
                          '/' +
                          dateTime.month.toString() +
                          '/' +
                          dateTime.year.toString() +
                          ' ' +
                          dateTime.hour.toString() +
                          ':' +
                          dateTime.minute.toString() +
                          ':' +
                          dateTime.second.toString();
                      customerPhone = contacts.isEmpty ? "" : contacts[0];
                      if (contacts.length > 1) {
                        customerPhone = customerPhone + ' / ' + contacts[1];
                      }
                      return returnCaseItem(
                          context,
                          index,
                          eachList[index]['bankName'],
                          caseIdList[index],
                          customerName == "" ? "Customer Name" : customerName,
                          eachList[index]['typeOfAsset'],
                          dateOfInspection == "" ? "Date" : dateOfInspection,
                          customerPhone == "" ? "9999999999" : customerPhone,
                          eachList[index]['address'] ?? ["one"],
                          eachList[index] ?? ["one"]);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),
    );
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            _toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(
                  _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(
          _PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(
            _PositionItemType.position,
            position.toString(),
          ));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  void _getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      _updatePositionList(
        _PositionItemType.position,
        position.toString(),
      );
    } else {
      _updatePositionList(
        _PositionItemType.log,
        'No last known position available',
      );
    }
  }

  void _getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    _updatePositionList(
      _PositionItemType.log,
      '$locationAccuracyStatusValue location accuracy granted.',
    );
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Application Settings.';
    } else {
      displayValue = 'Error opening Application Settings.';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}

class AppConstant {
  static List<Map<String, dynamic>> list = [
    {"title": "one", "id": "1", "lat": 23.7985053, "lon": 90.3842538},
    {"title": "two", "id": "2", "lat": 23.802236, "lon": 90.3700},
    {"title": "three", "id": "3", "lat": 23.8061939, "lon": 90.3771193},
  ];
}
