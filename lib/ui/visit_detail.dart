import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:property_valuation/ui/questionnaire.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboard.dart';

class VisitDetail extends StatefulWidget {
  const VisitDetail({Key? key}) : super(key: key);

  @override
  _VisitDetailState createState() => _VisitDetailState();
}

List latitudes = [];
List longitudes = [];
Map visitMap = {};
String caseId = '';
String customerName = '';
void getCaseDetail(Map map, String caseid, String name) {
  visitMap = map;
  caseId = caseid;
  customerName = name;
  print("This is map ${map["dateOfInspection"]}");
}

class _VisitDetailState extends State<VisitDetail> {
  Completer<GoogleMapController> _controller = Completer();
  Iterable _markers = Iterable.generate(latitudes.length, (index) {
    return Marker(
        markerId: MarkerId(AppConstant.list[index]['id']),
        position: LatLng(
          latitudes[index],
          longitudes[index],
        ),
        infoWindow: InfoWindow(title: AppConstant.list[index]["title"]));
  });
  _launchPhoneURL(String phoneNumber) async {
    String url = 'tel:' + phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final List<String> _dropdownValues = [
    "Postponed",
    "Client not Reachable",
    "Property not identified",
    "Loan cancelled by customer",
    "Could not visit"
  ];
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 30))))) {
      return true;
    }
    return false;
  }

  Future setVisitPostponed() async {
    var newDate = Timestamp.fromDate(now);
    var caseref = FirebaseFirestore.instance.collection('Cases').doc(caseId);
    await caseref
        .update({'caseStatus': 'Visit Postponed', 'dateOfInspection': newDate});
  }

  Future setUnableToVisit() async {
    var caseref = FirebaseFirestore.instance.collection('Cases').doc(caseId);
    await caseref.update({'caseStatus': 'Unable to Visit'});
  }

  Color tileColor = Colors.white;
  String dropdownValue = '';
  int _user = 0;
  String holder = '';
  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  DateTime now = DateTime.now();
  late String selectedDate = '';

  @override
  Widget build(BuildContext context) {
    _selectDate(BuildContext context) async {
      final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: now, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        selectableDayPredicate: _decideWhichDayToEnable,
      ))!;
      if (picked != now) {
        Navigator.pop(context);
        setState(() {
          now = picked;
          selectedDate = now.day.toString() +
              '/' +
              now.month.toString() +
              '/' +
              now.year.toString();
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Set New Date for visit as $selectedDate ?',
                      style: const TextStyle(
                          color: Colors.black, fontFamily: "BonaNova"),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.black, fontFamily: "BonaNova"),
                ),
              ),
              TextButton(
                onPressed: () {
                  setVisitPostponed();
                  final snackBar = SnackBar(content: Text('Visit Postponed'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.black, fontFamily: "BonaNova"),
                ),
              ),
            ],
          ),
        );
      }
    }

    List contacts = ['', ''];
    log("These are contacts==> $contacts");
    contacts = visitMap['contactNo'];
    Timestamp timestamp = visitMap['dateOfInspection'].toString() == ""
        ? Timestamp(40, 40)
        : visitMap['dateOfInspection'];
    DateTime dateTime =
        DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
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
    String customerPhone = contacts.toString();
    if (contacts.length > 1) {
      customerPhone = customerPhone + ' / ' + contacts[1];
    }
    latitudes.clear();
    longitudes.clear();
    setState(() {
      latitudes.add(visitMap['latitude']);
      longitudes.add(visitMap['longitude']);
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Property Evaluation'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Text(
                          visitMap['bankName'] == ""
                              ? ""
                              : visitMap['bankName'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: Text(
                          caseId,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  customerName,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions,
                              color: Colors.blue,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  visitMap['address'],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _launchPhoneURL(contacts[0]);
                                  },
                                  child: const Icon(
                                    Icons.phone_in_talk_sharp,
                                    color: Colors.green,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.white60,
                                    onPrimary: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Call Customer',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: GoogleMap(
                                          mapType: MapType.normal,
                                          zoomGesturesEnabled: true,
                                          myLocationEnabled: true,
                                          zoomControlsEnabled: true,
                                          initialCameraPosition: CameraPosition(
                                              target: LatLng(lat!, lon!),
                                              zoom: 10),
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            _controller.complete(controller);
                                          },
                                          markers: Set.from(_markers),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.map_rounded,
                                    color: Colors.blue,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.white60,
                                    onPrimary: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Route Map',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _launchPhoneURL('9930587574');
                                  },
                                  child: Icon(
                                    Icons.business_sharp,
                                    color: Colors.orange,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.white60,
                                    onPrimary: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Call Office',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        15,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text(
                            'Have You Completed the Visit?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                8,
                                        child: Center(
                                          child: Column(
                                            children: const [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text(
                                                'Do you wish to start filling the questionnaire?',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "BonaNova"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "BonaNova"),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            getVisitDetail(
                                                visitMap['address'],
                                                visitMap['bankBranchName'],
                                                visitMap['bankEmployeeName'],
                                                visitMap['bankName'],
                                                customerName,
                                                customerPhone,
                                                dateOfInspection,
                                                visitMap['instructions'],
                                                visitMap['jobBranch'],
                                                visitMap['latitude'].toString(),
                                                visitMap['longitude']
                                                    .toString(),
                                                visitMap['loanAcNo'],
                                                visitMap['purposeOfValuation'],
                                                visitMap['typeOfAsset']);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Questionnaire(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "BonaNova"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.thumb_up_outlined,
                                  color: Colors.green,
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(15),
                                  primary: Colors.white60,
                                  onPrimary: Colors.black,
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      content: Text(
                                        "Do you wish to cancel the Visit?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "BonaNova"),
                                      ),
                                      actions: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "BonaNova"),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              'Why is the visit being cancelled?',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child:
                                                            ListView.separated(
                                                          itemBuilder:
                                                              (buildContext,
                                                                  index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                if (_dropdownValues[
                                                                        index] ==
                                                                    "Postponed") {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            AlertDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      content:
                                                                          Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                4,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Text(
                                                                              'Select new date for visit',
                                                                              style: TextStyle(color: Colors.black, fontFamily: "BonaNova"),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () async {
                                                                                await _selectDate(context);
                                                                              },
                                                                              child: Icon(
                                                                                Icons.calendar_today_outlined,
                                                                                color: Colors.blue,
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(
                                                                                shape: CircleBorder(),
                                                                                padding: EdgeInsets.all(20),
                                                                                primary: Colors.white60,
                                                                                onPrimary: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  setUnableToVisit();
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        'Visit Cancelled'),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Dashboard()));
                                                                }
                                                              },
                                                              child: ListTile(
                                                                title: Text(
                                                                    _dropdownValues[
                                                                        index]),
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (buildContext,
                                                                  index) {
                                                            return Divider(
                                                                height: 1);
                                                          },
                                                          itemCount:
                                                              _dropdownValues
                                                                  .length,
                                                          shrinkWrap: true,
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text(
                                                      "Exit",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "BonaNova"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "BonaNova"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.thumb_down_outlined,
                                  color: Colors.red,
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(15),
                                  primary: Colors.white60,
                                  onPrimary: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
