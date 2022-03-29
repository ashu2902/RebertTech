import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:property_valuation/blocks/application_block.dart';
import 'package:property_valuation/ui/questionnaire.dart';
import 'package:provider/provider.dart';

import 'map_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../main.dart';
import 'dashboard.dart';

class SaleComparable extends StatefulWidget {
  const SaleComparable({Key? key}) : super(key: key);

  @override
  _SaleComparableState createState() => _SaleComparableState();
}
String caseIdoo='';
void getCaseId(String caseIdo){
  caseIdoo=caseIdo;
}
String location = '';
String latitude = '';
String longitude = '';
TextEditingController salelocationcontroller =
TextEditingController(text: '');
class _SaleComparableState extends State<SaleComparable> {
  var uuid = Uuid();
  String _locationValue = "";
  final _firestore = FirebaseFirestore.instance;
  late File _image=File('');
  String dropdownValue = '';
  Map<String, dynamic> saleMap={};
  String unitValue = 'Sq. Ft';
  String landrate = '';
  String landrateUnit = 'Sq. Ft';
  String landrateUnitHolder = '';
  String unitHolder = '';
  String holder = '';
  String sourceDetails = '';
  String saleDetails = '';
  String transactionDetails = '';
  int _user = 0;
  int _rateuser = 0;
  int _landuser = 0;
  late String url;
  late String downloadURL;
  String landArea = '';

  final List<String> _dropdownValues = [
    "Select a Property Type",
    "Residential Flat",
    "Residential Building",
    "Residential Row House",
    "Commercial Shop",
    "Commercial Complex",
    "Commercial Office",
    "Open Plot/Land",
    "Industrial Unit",
    "Plant & Machinery",
    "Vehicle"
  ];
  final List<String> _units = [
    "Sq. Ft",
    "Sq Yard",
    "Sq metre",
    "acre",
    "hectare"
  ];
  final List<String> _rateunits = [
    "Sq. Ft",
    "Sq Yard",
    "Sq metre",
    "acre",
    "hectare"
  ];

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
      unitHolder = unitValue;
      landrateUnit = landrateUnit;
    });
  }
  Future<void> setSaleDetail() async {
    var v4 = uuid.v4();
    print(saleMap);
    var arealocref = FirebaseFirestore.instance
        .collection('Sale Comparables')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('sale_comparable').doc(v4);
    await arealocref.set(saleMap);
  }
  String imagePicked = 'No images Uploaded';
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      PickedFile? image =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
          String filename = basename(_image.path);
          imagePicked = filename;
        });
      }
    }

    Future<String> uploadPic(BuildContext context) async {
      if (_image == null) {
        return "";
      } else {
        String filename = basename(_image.path);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(filename);
        /*await firebase_storage.FirebaseStorage.instance
              .ref(filename)
              .putFile(_image);*/
        firebase_storage.UploadTask task = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('salecomparables/$filename')
            .putFile(_image);
        var downUrl =
            await (await task.whenComplete(() => null)).ref.getDownloadURL();
        url = downUrl.toString();
        print(url);
        return url;
      }
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Property Evaluation'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'Sale Comparable',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: salelocationcontroller,
                    keyboardType: TextInputType.streetAddress,
                    onChanged: (value) {
                      location = value;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ApplicationBloc(),
                                  child: const MapView()),
                            ),
                          );
                        },
                        icon: const Icon(Icons.location_searching_outlined),
                      ),
                      hintText: 'Location',
                      labelText: 'Fetch Your Location',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: Center(
                    child: DropdownButton(
                      focusColor: Colors.blue,
                      dropdownColor: Colors.white,
                      value:
                          _landuser == null ? null : _dropdownValues[_landuser],
                      underline: Container(
                        height: 0,
                      ),
                      items: _dropdownValues
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          _landuser = _dropdownValues.indexOf(value.toString());
                          dropdownValue = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          landArea = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Land Area',
                          labelText: 'Land Area',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      width: 100,
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.transparent,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: Center(
                        child: DropdownButton(
                          focusColor: Colors.blue,
                          dropdownColor: Colors.white,
                          value: _user == null ? null : _units[_user],
                          underline: Container(
                            height: 0,
                          ),
                          items: _units
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              _user = _units.indexOf(value.toString());
                              unitValue = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          landrate = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Land Rate',
                          labelText: 'Land Rate',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '/',
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      width: 100,
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.transparent,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: Center(
                        child: DropdownButton(
                          focusColor: Colors.blue,
                          dropdownColor: Colors.white,
                          value:
                              _rateuser == null ? null : _rateunits[_rateuser],
                          underline: Container(
                            height: 0,
                          ),
                          items: _rateunits
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              _rateuser = _rateunits.indexOf(value.toString());
                              landrateUnit = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      sourceDetails = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Source Details',
                      labelText: 'Source Details',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      saleDetails = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Sale Details',
                      labelText: 'Sale Details',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      transactionDetails = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Transaction Details',
                      labelText: 'Transaction Details',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.transparent,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            await getImage();
                          },
                          child: Text(
                            "Add",
                            style:
                                TextStyle(fontSize: 14, fontFamily: "BonaNova"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('$imagePicked'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 16,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      if (latitude.isEmpty) {
                        const snackBar = SnackBar(
                            content: Text('Please enter a valid location'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else if (dropdownValue.isEmpty) {
                        const snackBar = SnackBar(
                            content:
                                Text('Please enter a valid property type'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else if (dropdownValue == 'Select a Property Type') {
                        final snackBar = SnackBar(
                            content:
                                Text('Please enter a valid property type'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else if (landArea.isEmpty) {
                        final snackBar = SnackBar(
                            content: Text('Please enter valid land area'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else if (landrate.isEmpty) {
                        final snackBar = SnackBar(
                            content: Text('Please enter a valid land rate'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else if (sourceDetails.isEmpty) {
                        final snackBar = SnackBar(
                            content: Text('Please enter valid source details'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else if (saleDetails.isEmpty) {
                        final snackBar = SnackBar(
                            content: Text('Please enter valid sale details'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else if (transactionDetails.isEmpty) {
                        final snackBar = SnackBar(
                            content:
                                Text('Please enter valid transaction details'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      showLoaderDialog(context);

                        downloadURL = await uploadPic(context);
                      
                      saleMap={
                        'caseId':caseIdoo,
                        'location':location,
                        'propertyType':dropdownValue,
                        'landArea': landArea,
                        'landAreaUnit':unitValue,
                        'landRate': landrate,
                        'landRateUnit': landrateUnit,
                        'sourceDetails': sourceDetails,
                        'saleDetails': saleDetails,
                        'transactionDetails':transactionDetails,
                        'doc':downloadURL
                      };

                      setSaleDetail();
                      const snackBar = SnackBar(
                        content: Text('Submitted Successfully!'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      return;
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 18, fontFamily: "BonaNova"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
