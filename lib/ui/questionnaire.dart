import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:path/path.dart';
import 'package:property_valuation/ui/sale_comparable.dart';
import 'package:property_valuation/ui/view_pdf.dart';
import 'package:property_valuation/ui/visit_detail.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../helpers/image_helper.dart';
import '../main.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

late String advance = '';
String contactNo = '';
String noOfWashrooms = '', noOfBathrooms = '', noOfToilets = '';
String bank = '';
String branch = '';
String valuationReportOf = '';
String nameOfClient = '';
String addressOfProperty = '';
String nameOfPresentOwner = '';
String dateOfInspection = '';
String plotArea = '';
String plotSize = '';
String bupArea = '';
String measuredBlupArea = '';
String yearOfConstruction = '';
String latLong = '';
String latitude = '';
String longitude = '';
String east = '';
String west = '';
String north = '';
String northEast = '';
String northWest = '';
String south = '';
String southEast = '';
String southWest = '';
String actualCostOfPurchase = '';
String expectedValuation = '';
String loanAmount = '';
String typeOfLoan = '';
String propertyType = '';
String storey = '';
String bankEmployee = '';
String instructions = '';
String jobBranch = '';
String loanAcNo = '';
String noOfVentilators = '';
String noOfWindows = '';
String flooring = '';
String kitchenPlatform = '';
String cuddapahShevles = '';
String purposeOfValuation = '';
String noOfWaterTanks = '';
String compoundWall = '';
String flooringInDev = '';
String boreWell = '';
String noOfSteps = '';
String extraInfo1 = '';
String extraInfo2 = '';
String extraInfo3 = '';
String extraInfo4 = '';
String extraInfo5 = '';
String noOfGate = '';

void getVisitDetail(
    String addresso,
    String branchNameo,
    String bankEmployeeNameo,
    String bankNameo,
    String customerNmaes,
    String contct,
    String date,
    String instr,
    String jobBrancho,
    String lati,
    String longi,
    String loan,
    String purpose,
    String type) {
  addressOfProperty = addresso;
  branch = branchNameo;
  bankEmployee = bankEmployeeNameo;
  bank = bankNameo;
  nameOfClient = customerNmaes;
  valuationReportOf = customerNmaes;
  contactNo = contct;
  dateOfInspection = date;
  instructions = instr;
  jobBranch = jobBranch;
  latitude = lati;
  longitude = longi;
  loanAcNo = loan;
  purposeOfValuation = purpose;
}

class _QuestionnaireState extends State<Questionnaire>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  late TabController _tabController;
  final List<String> typesOfStairs = [
    'type of stairs',
    'RCC',
    'Ms Steel',
    'Wooden'
  ];
  final List<String> typesOfRailings = [
    'type of railings',
    'RCC',
    'MS',
    'Wooden',
    'SS'
  ];
  final List<String> _units = [
    "Sq. Ft",
    "Sq Yard",
    "Sq metre",
    "acre",
    "hectare"
  ];
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
  final List<String> structureList = [
    'Structure Type',
    'Load Bearing',
    'RCC Frame',
    'MS Frame',
    'Composite Structure',
    'PEB Structure'
  ];
  final List<String> brickalls = ['4"', '6"', '9"', '13"'];
  final List<String> wallFinishList = ['sid finish', 'paint'];
  final List<String> typesOfVentilation = [
    'select',
    'T.W. Door',
    'MSRS',
    'Glass',
    'Fiber'
  ];
  final List<String> typesOfDocuments = [
    'Sell DeeD',
    'Lease Deed',
    'Search report',
    'Building Permission and Commencement Letter',
    'Completion/ Occupation Certificate',
    'NA order',
    'Sanctioned Layout Plan',
    '7/12 Extract',
    'PTR (Namuna number 8)',
    'Land Map',
    'Deed of Declaration',
    'Invoice of Machinery',
    'Balance Sheet'
  ];
  final List<String> typesOfPipes = [
    'select',
    'Ordinary',
    'Industrial',
    'Concealed',
    'Casing Capping',
    'Conduit'
  ];
  final List<String> tankType = ['select', 'Gr.', 'HDPE'];
  final List<String> workTypes = [
    'select',
    'Furniture',
    'Fixture',
    'Fittings',
    'Interior'
  ];
  final List<String> roofingTypes = [
    'RCC Slab',
    'Slanted MS Truss with A.C. sheet',
    'Slanted MS Truss with G.I. sheet'
  ];
  int stair = 0;
  int rail = 0;
  String typeOfStair = '', typeOfRailing = '';
  int slab = 0;
  String typeOfRoofing = '';
  int doc = 0;
  String docValue = '';
  int work = 0;
  String workValue = '';
  int tank = 0;
  String tankValue = '';
  int pipe = 0;
  String pipeValue = '';
  int vent = 0;
  String ventiValue = '';
  int finish = 0;
  String finishValue = '';
  String finishHolder = '';
  int brick = 0;
  String brichHolder = '';
  String brickValue = '';
  int _struct = 0;
  String _structHolder = 'a';
  String _structValue = 'a';
  int _userr = 0;
  String typeHolder = '';
  int _user = 0;
  int _plotSizeInt = 0;
  int _bupInt = 0;
  int _mbupInt = 0;
  String noOfFloors = '';
  String mbupholder = '';
  String mbupValue = 'Sq. Ft';
  String bupHolder = '';
  String bupValue = 'Sq. Ft';
  String plotSizeHolder = '';
  String plotSizeValue = 'Sq. Ft';
  String unitHolder = '';
  String unitValue = 'Sq. Ft';
  DateTime now = DateTime.now();
  List<String> documents = [];
  List<String> documentNames = [];
  late String selectedDate = dateOfInspection;
  late Map<String, dynamic> visitDetailMap = {};
  late Map<String, dynamic> areaLocationMap = {};
  late Map<String, dynamic> documentsMap = {};
  late Map<String, dynamic> valuationDetailMap = {};
  late Map<String, dynamic> propertyDetails = {};
  late File _image;
  late String url, documentName = typesOfDocuments[0];
  List<String> downloadURL = [];
  String imagePicked = 'No images Uploaded';
  DateTime _selectedYear = DateTime.now();

  void getDropDownItem() {
    setState(() {
      unitHolder = unitValue;
      plotSizeHolder = plotSizeValue;
      bupHolder = bupValue;
      mbupholder = mbupValue;
      typeHolder = propertyType;
    });
  }

  Future<String?> _selectImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickFromGallery(
        context: context, cropStyle: CropStyle.rectangle, title: "Image");
    if (pickedFile != null) {
      String filename = basename(pickedFile.path);
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(filename);
      final userId = FirebaseAuth.instance.currentUser!.uid;
      firebase_storage.UploadTask task = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('propertyImages/$userId/$filename')
          .putFile(pickedFile);
      var downUrl =
          await (await task.whenComplete(() => null)).ref.getDownloadURL();
      url = downUrl.toString();
      print(url);
      return url;
    }
    return null;
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
          .child('$caseId/$filename')
          .putFile(_image);
      var downUrl =
          await (await task.whenComplete(() => null)).ref.getDownloadURL();
      setState(() {
        url = downUrl.toString();
        documentController.clear();
        documents.add(url);
        documentNames.add(documentName);
        _image.delete();
      });

      return url;
    }
  }

  TextEditingController documentController = TextEditingController(text: '');
  bool dataAdded = false;
  Future<bool> setVisitDetail() async {
    print(visitDetailMap);
    var visitref = FirebaseFirestore.instance
        .collection('Field Visits')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(caseId)
        .doc('visit detail');
    await visitref.set(visitDetailMap).whenComplete(() => dataAdded = true);
    setState(() {
      dataAdded = true;
    });

    var caseref = FirebaseFirestore.instance.collection('Cases').doc(caseId);
    await caseref.update({'caseStatus': 'Partially Done'});
    return dataAdded;
  }

  Future<bool> setAreaDetail() async {
    print(areaLocationMap);
    var arealocref = FirebaseFirestore.instance
        .collection('Field Visits')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(caseId)
        .doc('Area and Location');
    await arealocref.set(areaLocationMap).whenComplete(() => dataAdded = true);
    setState(() {
      dataAdded = true;
    });
    return dataAdded;
  }

  Future<bool> setDocAndDirectionDetail() async {
    print(documentsMap);
    var visitref = FirebaseFirestore.instance
        .collection('Field Visits')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(caseId)
        .doc('Documents and Directions');
    await visitref.set(documentsMap).whenComplete(() => dataAdded = true);
    setState(() {
      dataAdded = true;
    });
    return dataAdded;
  }

  Future<bool> setValuationDetail() async {
    print(valuationDetailMap);
    var arealocref = FirebaseFirestore.instance
        .collection('Field Visits')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(caseId)
        .doc('Valuation Detail');
    await arealocref
        .set(valuationDetailMap)
        .whenComplete(() => dataAdded = true);
    setState(() {
      dataAdded = true;
    });
    return dataAdded;
  }

  Future<bool> setPropertyDetail() async {
    print(propertyDetails);
    var arealocref = FirebaseFirestore.instance
        .collection('Field Visits')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(caseId)
        .doc('Property Detail');
    await arealocref.set(propertyDetails).whenComplete(() => dataAdded = true);
    setState(() {
      dataAdded = true;
    });
    var caseref = FirebaseFirestore.instance.collection('Cases').doc(caseId);
    await caseref.update({'caseStatus': 'Visit Complete'});
    return dataAdded;
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs args, BuildContext context) {
    setState(() {
      DateTime _date = args.value;
      selectedDate = _date.day.toString() +
          '/' +
          _date.month.toString() +
          '/' +
          _date.year.toString();
      Navigator.pop(context);
    });
  }

  Future getImage() async {
    FilePickerResult? image = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (image != null) {
      setState(() {
        String? path = image.files.single.path;
        _image = File(path!);
        String filename = basename(_image.path);
        imagePicked = filename;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectDate(BuildContext context) async {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: SfDateRangePicker(
                onSelectionChanged: (val) => _onSelectionChanged(val, context),
                selectionMode: DateRangePickerSelectionMode.single,
                enablePastDates: true,
                maxDate: DateTime.now(),
              ),
            ),
          ),
        ),
      );
    }

    String selectedYear = _selectedYear.year.toString();
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
          bottom: new TabBar(controller: _tabController, tabs: const [
            Tab(
              text: '',
            ),
            Tab(
              text: '',
            ),
            Tab(
              text: '',
            ),
            Tab(
              text: '',
            ),
            Tab(
              text: '',
            ),
          ]),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Field Visits')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(caseId)
                    .doc('visit detail')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  if (snapshot.data!.exists) {
                    final message = snapshot.data!;

                    print(message.data());
                    advance = message.get('advance');
                    print(advance);
                    contactNo = message.get('contactNo');
                    print("This is contact number$contactNo");
                    bank = message.get('bankName');
                    branch = message.get('bankBranch');
                    valuationReportOf = message.get('valuationReportOf');
                    nameOfClient = message.get('nameOfClient');
                    nameOfPresentOwner = message.get('nameOfPresentOwner');
                    dateOfInspection = message.get('dateOfInspection');
                    addressOfProperty = message.get('address');
                    extraInfo1 = message.get('otherDetails');
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Visit Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: advance,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                advance = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Advance',
                                labelText: 'Advance',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                contactNo = value;
                              },
                              initialValue: contactNo,
                              decoration: const InputDecoration(
                                hintText: 'Contact Number',
                                labelText: 'Contact Number',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                bank = value;
                              },
                              initialValue: bank,
                              decoration: const InputDecoration(
                                hintText: 'Bank Name',
                                labelText: 'Bank Name',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                branch = value;
                              },
                              initialValue: branch,
                              decoration: const InputDecoration(
                                hintText: 'Bank Branch',
                                labelText: 'Bank Branch',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                valuationReportOf = value;
                              },
                              initialValue: valuationReportOf,
                              decoration: const InputDecoration(
                                hintText: 'Valuation Report of',
                                labelText: 'Valuation Report of',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                nameOfClient = value;
                              },
                              initialValue: nameOfClient,
                              decoration: const InputDecoration(
                                hintText: 'Name of Client',
                                labelText: 'Name of Client',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: nameOfPresentOwner,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                nameOfPresentOwner = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Name of Present Owner',
                                labelText: 'Name of Present Owner',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: extraInfo1,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                extraInfo1 = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'More Info',
                                labelText: 'More Info',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                      child: Icon(
                                        Icons.date_range,
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
                                        'Date of Inspection',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Text('$selectedDate'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Icon(
                                        Icons.map_sharp,
                                        color: Colors.green,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        primary: Colors.white60,
                                        onPrimary: Colors.black,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Address of Property',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Text(
                                              addressOfProperty,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (advance.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter advance'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (contactNo.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter contact'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (bank.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter bank name'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (branch.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter bank branch name'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (valuationReportOf.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter valuation report of'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (nameOfClient.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter name of the Client'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (nameOfPresentOwner.isEmpty) {
                              const snackBar = SnackBar(
                                  content:
                                      Text('Enter name of the present owner'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (selectedDate.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Select a date of Inspection'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (addressOfProperty.isEmpty) {
                              const snackBar = SnackBar(
                                  content:
                                      Text('Enter address of the property'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            } else {
                              String cnt1 = contactNo.substring(0, 9);
                              String cnt2 = '';
                              if (contactNo.length > 10) {
                                cnt2 = contactNo.substring(13, 22);
                              }
                              var contact = {cnt1, cnt2};
                              visitDetailMap = {
                                'advance': advance,
                                'contactNo': contactNo,
                                'bankName': bank,
                                'bankBranch': branch,
                                'valuationReportOf': valuationReportOf,
                                'nameOfClient': nameOfClient,
                                'nameOfPresentOwner': nameOfPresentOwner,
                                'dateOfInspection': selectedDate,
                                'address': addressOfProperty,
                                'otherDetails': extraInfo1,
                              };
                              setVisitDetail();
                              const snackBar =
                                  SnackBar(content: Text('Data Saved'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              _tabController.animateTo((1));
                            }
                          },
                          child: const Text('Save and Continue'),
                        ),
                      ],
                    ),
                  );
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Field Visits')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(caseId)
                    .doc('Area and Location')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  if (snapshot.data!.exists) {
                    final message = snapshot.data!;
                    plotArea = message.get('landArea');
                    plotSize = message.get('plotSize');
                    bupArea = message.get('bupArea');
                    measuredBlupArea = message.get('measuredBupArea');
                    selectedYear = message.get('yearOfConstruction');
                    latitude = message.get('latitude');
                    longitude = message.get('longitude');
                    extraInfo2 = message.get('otherDetails');
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Area and Location',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  initialValue: plotArea,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    plotArea = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Land Area',
                                    labelText: 'Land Area',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _user =
                                            _units.indexOf(value.toString());
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
                              padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  initialValue: plotSize,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    plotSize = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Plot Size',
                                    labelText: 'Plot Size',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                                    value: _plotSizeInt == null
                                        ? null
                                        : _units[_plotSizeInt],
                                    underline: Container(
                                      height: 0,
                                    ),
                                    items: _units
                                        .map(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _plotSizeInt =
                                            _units.indexOf(value.toString());
                                        plotSizeValue = value.toString();
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
                              padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  initialValue: bupArea,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    bupArea = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'B/UP Area',
                                    labelText: 'B/UP Area',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                                    value: _bupInt == null
                                        ? null
                                        : _units[_bupInt],
                                    underline: Container(
                                      height: 0,
                                    ),
                                    items: _units
                                        .map(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _bupInt =
                                            _units.indexOf(value.toString());
                                        bupValue = value.toString();
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
                              padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  initialValue: measuredBlupArea,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    measuredBlupArea = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Measured B/UP Area',
                                    labelText: 'Measured B/UP Area',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                                    value: _mbupInt == null
                                        ? null
                                        : _units[_mbupInt],
                                    underline: Container(
                                      height: 0,
                                    ),
                                    items: _units
                                        .map(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _mbupInt =
                                            _units.indexOf(value.toString());
                                        mbupValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: extraInfo2,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                extraInfo2 = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'More Info',
                                labelText: 'More Info',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Select a Year"),
                                              content: Container(
                                                // Need to use container to add size constraint.
                                                width: 300,
                                                height: 300,
                                                child: YearPicker(
                                                  firstDate: DateTime(
                                                      DateTime.now().year - 100,
                                                      1),
                                                  lastDate: DateTime(
                                                      DateTime.now().year),
                                                  initialDate: DateTime.now(),
                                                  // save the selected date to _selectedDate DateTime variable.
                                                  // It's used to set the previous selected date when
                                                  // re-showing the dialog.
                                                  selectedDate: _selectedYear,
                                                  onChanged:
                                                      (DateTime dateTime) {
                                                    // close the dialog when year is selected.
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _selectedYear = dateTime;
                                                    });

                                                    // Do something with the dateTime selected.
                                                    // Remember that you need to use dateTime.year to get the year
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.orange,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(20),
                                        primary: Colors.white60,
                                        onPrimary: Colors.black,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Year of Construction',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Text('$selectedYear'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.map_sharp,
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
                                        'Latitude, Longitude',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Row(
                                        children: [
                                          Flexible(
                                              child: Text('$latitude' +
                                                  '/ ' +
                                                  ' $longitude')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (plotArea.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter land Area'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (plotSize.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter plot size'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (bupArea.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter B/UP area'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (measuredBlupArea.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter measured B/UP area'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (selectedYear.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter year of Construction'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (latitude.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter latitude'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            if (longitude.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter longitude'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            } else {
                              areaLocationMap = {
                                'landArea': plotArea,
                                'plotSize': plotSize,
                                'bupArea': bupArea,
                                'measuredBupArea': measuredBlupArea,
                                'yearOfConstruction': selectedYear,
                                'latitude': latitude,
                                'longitude': longitude,
                                'plotSizeUnit': plotSizeValue,
                                'plotAreaUnit': unitValue,
                                'bupUnit': bupValue,
                                'measuredBupUnit': mbupValue,
                                'otherDetails': extraInfo2
                              };
                              setAreaDetail();
                              const snackBar =
                                  SnackBar(content: Text('Data Saved'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              _tabController.animateTo((2));
                            }
                            //_tabController.animateTo((2));
                          },
                          child: Text('Save and Continue'),
                        ),
                      ],
                    ),
                  );
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Field Visits')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(caseId)
                    .doc('Documents and Directions')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  if (snapshot.data!.exists) {
                    final message = snapshot.data!;

                    east = message.get('E');
                    west = message.get('W');
                    north = message.get('N');
                    south = message.get('S');
                    northEast = message.get('NE');
                    northWest = message.get('NW');
                    southEast = message.get('SE');
                    southWest = message.get('SW');
                    extraInfo3 = message.get('otherDetails');
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Documents & Directions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
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
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Documents',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              15, 10, 15, 0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 60,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.blue,
                                                style: BorderStyle.solid,
                                                width: 0.80),
                                          ),
                                          child: Center(
                                            child: DropdownButton(
                                              focusColor: Colors.blue,
                                              dropdownColor: Colors.white,
                                              value: typesOfDocuments[doc],
                                              underline: Container(
                                                height: 0,
                                              ),
                                              items: typesOfDocuments
                                                  .map(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              isExpanded: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  doc =
                                                      typesOfDocuments.indexOf(
                                                          value.toString());
                                                  documentName =
                                                      value.toString();
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (documentName.isEmpty) {
                                        const snackBar = SnackBar(
                                            content:
                                                Text('Enter document name'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        return;
                                      }
                                      if (documentNames
                                          .contains(documentName)) {
                                        const snackBar = SnackBar(
                                            content: Text(
                                                'Document already Exists'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        return;
                                      } else {
                                        await getImage();
                                        await uploadPic(context);
                                      }
                                      print(documents);
                                    },
                                    child: const Icon(
                                      Icons.file_upload,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                      primary: Colors.white60,
                                      onPrimary: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Upload File',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    key: UniqueKey(),
                                    itemCount: documents.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 5, 15, 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ViewPdf(
                                                      text: documents[index])),
                                            );
                                          },
                                          child: Card(
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          '${documentNames[index]}'),
                                                    ),
                                                    Flexible(
                                                      child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              documentNames
                                                                  .removeAt(
                                                                      index);
                                                              documents
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            size: 20,
                                                            color: Colors.blue,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.5,
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
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Images',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                30, 10, 30, 10),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: downloadURL.isEmpty
                                                      ? const Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          color: Colors.blue,
                                                          size: 50,
                                                        )
                                                      : _buildImagesCard(
                                                          context),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      20,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      final url =
                                                          await _selectImage(
                                                              context);
                                                      print('++++++++++$url');
                                                      url != null
                                                          ? downloadURL.add(url)
                                                          : null;
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      "Add",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "BonaNova"),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1.5,
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
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Directions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'E :',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: east,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                east = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'W :',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: west,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                west = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'N :',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: north,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                north = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'S :',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: south,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                south = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'NE :',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: northEast,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                northEast = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'NW :',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: northWest,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                northWest = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'SE :',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: southEast,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                southEast = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'SW:',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              initialValue: southWest,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                southWest = value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: extraInfo3,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                extraInfo3 = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'More Info',
                                labelText: 'More Info',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (east.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter East Direction'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            if (west.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter West Direction'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            if (north.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter North Direction'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            if (south.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter South Direction'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (documentNames.isNotEmpty &&
                                  documents.isNotEmpty) {
                                for (int i = 0; i < documentNames.length; i++) {
                                  documentsMap[documentNames[i]] = documents[i];
                                }
                              }
                              documentsMap['images'] = downloadURL;
                              documentsMap['E'] = east;
                              documentsMap['W'] = west;
                              documentsMap['N'] = north;
                              documentsMap['S'] = south;
                              documentsMap['NE'] = northEast;
                              documentsMap['NW'] = northWest;
                              documentsMap['SE'] = southEast;
                              documentsMap['SW'] = southWest;
                              documentsMap['otherDetails'] = extraInfo3;
                              print(documentsMap);
                              setDocAndDirectionDetail();
                              const snackBar =
                                  SnackBar(content: Text('Data Saved'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              _tabController.animateTo(3);
                            }

                            print(_tabController.index.toString());
                          },
                          child: Text('Save and Continue'),
                        ),
                      ],
                    ),
                  );
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Field Visits')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(caseId)
                    .doc('Valuation Detail')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  if (snapshot.data!.exists) {
                    final message = snapshot.data!;
                    actualCostOfPurchase = message.get('actualCostOfPurchase');
                    expectedValuation = message.get('expectedValuation');
                    loanAcNo = message.get('loanAcNo');
                    typeOfLoan = message.get('typeOfLoan');
                    purposeOfValuation = message.get('purposeOfValuation');
                    loanAmount = message.get('loanAmount');
                    extraInfo4 = message.get('otherDetails');
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Valuation Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: actualCostOfPurchase,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                actualCostOfPurchase = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Actual cost of Purchase',
                                labelText: 'Actual cost of purchase',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: expectedValuation,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                expectedValuation = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Expected Valuation',
                                labelText: 'Expected Valuation',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: loanAmount,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                loanAmount = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Loan Amount',
                                labelText: 'Loan Amount',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: typeOfLoan,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                typeOfLoan = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Type of Loan',
                                labelText: 'Type of Loan',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: purposeOfValuation,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                actualCostOfPurchase = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Purpose of Valuation',
                                labelText: 'Purpose of Valuation',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: loanAcNo,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                loanAcNo = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Loan Account number',
                                labelText: 'Loan Account number',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: extraInfo4,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                extraInfo4 = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'More Info',
                                labelText: 'More Info',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (actualCostOfPurchase.isEmpty) {
                              const snackBar = SnackBar(
                                  content:
                                      Text('Enter actual cost of purchase'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (expectedValuation.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter expected Valuation'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (loanAmount.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter loan amount'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (typeOfLoan.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text('Enter type of Loan'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (purposeOfValuation.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter purpose of Valuation'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (loanAcNo.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter loan account number'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              showLoaderDialog(context);

                              valuationDetailMap = {
                                'actualCostOfPurchase': actualCostOfPurchase,
                                'expectedValuation': expectedValuation,
                                'loanAmount': loanAmount,
                                'typeOfLoan': typeOfLoan,
                                'purposeOfValuation': purposeOfValuation,
                                'loanAcNo': loanAcNo,
                                'otherDetails': extraInfo4,
                              };
                              setValuationDetail().then((value) {
                                Navigator.pop(context);
                                _tabController.animateTo(4);
                              });
                            }
                          },
                          child: Text('Save and Continue'),
                        ),
                      ],
                    ),
                  );
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Field Visits')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(caseId)
                    .doc('Property Details')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  if (snapshot.data!.exists) {
                    final message = snapshot.data!;
                    typeOfRoofing = message.get('typesOfRoofing');
                    noOfFloors = message.get('noOfFloors');
                    propertyType = message.get('propertyType');
                    _structValue = message.get('structureType');
                    brickValue = message.get('brickWallThickness');
                    finishValue = message.get('finishing');
                    ventiValue = message.get('typeOfVentilators');
                    noOfVentilators = message.get('noOfVentilators');
                    noOfWindows = message.get('noOfWindows');
                    flooring = message.get('flooring');
                    pipeValue = message.get('typeOfPipe');
                    noOfWashrooms = message.get('noOfWashrooms');
                    noOfBathrooms = message.get('noOfBathrooms');
                    noOfToilets = message.get('noOfToilets');
                    kitchenPlatform = message.get('kitchenPlatform');
                    cuddapahShevles = message.get('cuddapahShelves');
                    noOfWaterTanks = message.get('noOfWaterTanks');
                    tankValue = message.get('typeOfWaterTank');
                    workValue = message.get('work');
                    compoundWall = message.get('compoundWalls');
                    flooringInDev = message.get('flooringInDev');
                    boreWell = message.get('boreWell');
                    extraInfo5 = message.get('otherDetails');
                    noOfGate = message.get('noOfGates');
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: Center(
                              child: DropdownButton(
                                focusColor: Colors.blue,
                                dropdownColor: Colors.white,
                                value: _userr == null
                                    ? null
                                    : _dropdownValues[_userr],
                                underline: Container(
                                  height: 0,
                                ),
                                items: _dropdownValues
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _userr = _dropdownValues
                                        .indexOf(value.toString());
                                    propertyType = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('P/B+G+ : '),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfWindows,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfFloors = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      label: Text("No of Floors"),
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: Center(
                              child: DropdownButton(
                                focusColor: Colors.blue,
                                dropdownColor: Colors.white,
                                value: _struct == null
                                    ? null
                                    : structureList[_struct],
                                underline: Container(
                                  height: 0,
                                ),
                                items: structureList
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _struct =
                                        structureList.indexOf(value.toString());
                                    _structValue = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: Center(
                              child: DropdownButton(
                                focusColor: Colors.blue,
                                dropdownColor: Colors.white,
                                value: slab == null ? null : roofingTypes[slab],
                                underline: Container(
                                  height: 0,
                                ),
                                items: roofingTypes
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    slab =
                                        roofingTypes.indexOf(value.toString());
                                    typeOfRoofing = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Brick Walls thickness:'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 2, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      focusColor: Colors.blue,
                                      dropdownColor: Colors.white,
                                      value: brick == null
                                          ? null
                                          : brickalls[brick],
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: brickalls
                                          .map(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          brick = brickalls
                                              .indexOf(value.toString());
                                          brickValue = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Finishing:'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      focusColor: Colors.blue,
                                      dropdownColor: Colors.white,
                                      value: finish == null
                                          ? null
                                          : wallFinishList[finish],
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: wallFinishList
                                          .map(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          finish = wallFinishList
                                              .indexOf(value.toString());
                                          finishValue = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      focusColor: Colors.blue,
                                      dropdownColor: Colors.white,
                                      value: vent == null
                                          ? null
                                          : typesOfVentilation[vent],
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: typesOfVentilation
                                          .map(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          vent = typesOfVentilation
                                              .indexOf(value.toString());
                                          ventiValue = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const Text('Ventilators'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfVentilators,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfVentilators = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Windows: '),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfWindows,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfWindows = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      label: Text("No of windows"),
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Flooring: '),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: flooring,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      flooring = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      label: Text("Flooring"),
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Light Fitting'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 2, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      focusColor: Colors.blue,
                                      dropdownColor: Colors.white,
                                      value: pipe == null
                                          ? null
                                          : typesOfPipes[pipe],
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: typesOfPipes
                                          .map(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          pipe = typesOfPipes
                                              .indexOf(value.toString());
                                          pipeValue = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const Text('pipe.'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('No. Of WC: '),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfWashrooms,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfWashrooms = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('No. Of Bathrooms:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfBathrooms,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfBathrooms = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('No. Of Toilets:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfToilets,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfToilets = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Kitchen Platforms:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: kitchenPlatform,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      kitchenPlatform = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Cuddapah Shelves:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: cuddapahShevles,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      cuddapahShevles = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: Center(
                              child: DropdownButton(
                                focusColor: Colors.blue,
                                dropdownColor: Colors.white,
                                value:
                                    stair == null ? null : typesOfStairs[stair],
                                underline: Container(
                                  height: 0,
                                ),
                                items: typesOfStairs
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    stair =
                                        typesOfStairs.indexOf(value.toString());
                                    typeOfStair = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blue,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: Center(
                              child: DropdownButton(
                                focusColor: Colors.blue,
                                dropdownColor: Colors.white,
                                value:
                                    rail == null ? null : typesOfRailings[rail],
                                underline: Container(
                                  height: 0,
                                ),
                                items: typesOfRailings
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    rail = typesOfRailings
                                        .indexOf(value.toString());
                                    typeOfRailing = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('No of Steps:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfSteps,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfSteps = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('No of Gates:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfGate,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfGate = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('No of Water Tanks:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: noOfWaterTanks,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      noOfWaterTanks = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Type of Water Tank'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 2, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      focusColor: Colors.blue,
                                      dropdownColor: Colors.white,
                                      value:
                                          tank == null ? null : tankType[tank],
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: tankType
                                          .map(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          tank = tankType
                                              .indexOf(value.toString());
                                          tankValue = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Work:'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 2, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      focusColor: Colors.blue,
                                      dropdownColor: Colors.white,
                                      value:
                                          work == null ? null : workTypes[work],
                                      underline: Container(
                                        height: 0,
                                      ),
                                      items: workTypes
                                          .map(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          work = workTypes
                                              .indexOf(value.toString());
                                          workValue = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Compound Walls: '),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: compoundWall,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      compoundWall = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Flooring in Site Development: '),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: flooringInDev,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      flooringInDev = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Bore Well: '),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: boreWell,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      boreWell = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              initialValue: extraInfo5,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                extraInfo5 = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'More Info',
                                labelText: 'More Info',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (loanAcNo.isEmpty) {
                              const snackBar = SnackBar(
                                  content: Text('Enter loan account number'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              propertyDetails = {
                                'noOfSteps': noOfSteps,
                                'noOfGates': noOfGate,
                                'typeOfRailing': typeOfRailing,
                                'typeOfStairs': typeOfStair,
                                'noOfFloors': noOfFloors,
                                'propertyType': actualCostOfPurchase,
                                'structureType': expectedValuation,
                                'loanAmount': loanAmount,
                                'brickWallThickness': brickValue,
                                'finishing': finishValue,
                                'typeOfVentilators': ventiValue,
                                'noOfVentilators': noOfVentilators,
                                'noOfWindows': noOfWindows,
                                'flooring': flooring,
                                'typeOfPipe': pipeValue,
                                'noOfWashrooms': noOfWashrooms,
                                'noOfBathrooms': noOfBathrooms,
                                'noOfToilets': noOfToilets,
                                'kitchenPlatform': kitchenPlatform,
                                'cuddapahShelves': cuddapahShevles,
                                'noOfWaterTanks': noOfWaterTanks,
                                'typeOfWaterTank': tankValue,
                                'work': work,
                                'compoundWalls': compoundWall,
                                'flooringInDev': flooringInDev,
                                'boreWell': boreWell,
                                'typeOfRoofing': typeOfRoofing,
                                'otherDetails': extraInfo5,
                              };
                              setPropertyDetail();
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: const Text(
                                    "Do you wish to add a Sale Comparable?",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "BonaNova"),
                                  ),
                                  actions: <Widget>[
                                    // ignore: deprecated_member_use
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text(
                                          "No",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "BonaNova"),
                                        )),
                                    FlatButton(
                                      onPressed: () {
                                        getCaseId(caseId);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SaleComparable()),
                                        );
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "BonaNova"),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  _buildImagesCard(BuildContext context) {
    return Container(
      width: 110,
      height: 150,
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(thickness: 2),
        scrollDirection: Axis.horizontal,
        itemBuilder: (__, index) {
          return _buildImage(downloadURL[index], context);
        },
        itemCount: downloadURL.length,
      ),
    );
  }

  _buildImage(String url, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return Image.network(url, fit: BoxFit.cover);
            });
      },
      child: SizedBox(
        height: 110,
        width: 110,
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }
}
