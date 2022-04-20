import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:property_valuation/blocks/application_block.dart';
import 'package:property_valuation/ui/questionnaire.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../main.dart';
import 'map_view.dart';

class CreateCase extends StatefulWidget {
  const CreateCase({Key? key}) : super(key: key);
  @override
  _CreateCaseState createState() => _CreateCaseState();
}

String lati = '';
String longi = '';
String address = '';
String vicinity = '';

class _CreateCaseState extends State<CreateCase> {
  var uuid = Uuid();
  int borrowers = 5;
  String contact = '';
  List<String> contacts = [];
  List<Map<String, String>> borrowerNames = [];
  List<String> prefixes = [];
  String fullName = '',
      title = '',
      caseStatus = 'NotAssigned',
      district = '',
      instructions = '',
      jobBranch = '',
      loanAcNo = '',
      locality = '',
      pincode = '',
      purposeOfValuation = '',
      state = '',
      typeOfAsset = '';
  int bank = 0;
  int _user = 0;
  String bankName = '';
  List<String> bankNames = [];
  int branch = 0;
  String bankBranchName = '';
  List<String> bankBranchNames = [];
  int employee = 0;
  String bankEmployeeName = '';
  List<String> bankEmployeeNames = [];
  int purpose = 0;
  final List<String> purposes = [
    'Purpose of Valuation',
    'Income Tax',
    'Banking/Financial Institute',
    'Banking(Auction/Settlement of Dues',
    'Visa Purpose',
    'Personal Purpose'
  ];
  int _userr = 0;
  final List<String> _units = ['Mr.', 'Miss', 'Mrs.'];
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
  String selectedDate = '';
  late DateTime date;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController localityController = TextEditingController();

  Map<String, dynamic> caseMap = {};
  Future<void> createNewCase() async {
    var v4 = uuid.v4();
    var visitref = FirebaseFirestore.instance.collection('Cases').doc(v4);
    await visitref.set(caseMap);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      address;
      vicinity;
      addressController.text = address;
      String temp = '';
      List<String> elephantList = address.split(",");

      if (elephantList.length > 2) {
        print(elephantList);
        temp = elephantList[elephantList.length - 2];
      }

      List<String> statePin = temp.split(' ');
      print(statePin);
      if (statePin.length > 1) {
        state = statePin[1];
        stateController.text = state;
        pincode = statePin[1];
      }

      pinController.text = pincode;
      locality = vicinity;
      localityController.text = locality;
    });
    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      setState(() {
        DateTime _date = args.value;
        selectedDate = _date.day.toString() +
            '/' +
            _date.month.toString() +
            '/' +
            _date.year.toString();
        date = _date;
        Navigator.pop(context);
      });
    }

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
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.single,
                enablePastDates: true,
                minDate: DateTime.now(),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Property Evaluation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'Create Case',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Banks').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  bankNames.clear();
                  for (var message in messages) {
                    if (!bankNames.contains(message.get('bankName'))) {
                      bankNames.add(message.get('bankName'));
                    }
                  }
                  if (bankNames.isNotEmpty) {
                    return Padding(
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
                            value: bank == null ? null : bankNames[bank],
                            underline: Container(
                              height: 0,
                            ),
                            items: bankNames
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
                                bank = bankNames.indexOf(value.toString());
                                bankName = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    child: Text('No banks to show!'),
                  );
                }),
            returnBankDropDown(),
            returnEmployeeDown(),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    dropdownColor: Colors.white,
                    value: _userr == null ? null : _dropdownValues[_userr],
                    underline: Container(
                      height: 0,
                    ),
                    items: _dropdownValues
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _userr = _dropdownValues.indexOf(value.toString());
                        propertyType = value.toString();
                      });
                    },
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
                          child: const Icon(
                            Icons.date_range,
                            color: Colors.orange,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(20),
                            primary: Colors.white60,
                            onPrimary: Colors.black,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Date of Inspection',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Text(selectedDate),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
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
                            'Latitude/Longitude',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  '$lati/ $longi',
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 10),
                  child: Container(
                    width: 80,
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
                            title = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        fullName = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Borrower Name',
                        labelText: 'Borrower Name',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      if (fullName.isNotEmpty) {
                        setState(() {
                          borrowerNames
                              .add({'title': title, 'fullName': fullName});
                        });
                      }
                      _fullNameController.clear();
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: ListView.builder(
                  itemCount: borrowerNames.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: Card(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                      '${borrowerNames[index]['title']} ${borrowerNames[index]['fullName']}'),
                                ),
                                Flexible(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          borrowerNames.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        size: 20,
                                        color: Colors.blue,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        contact = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Contact',
                        labelText: 'Contact',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (contact.isNotEmpty) {
                        setState(() {
                          contacts.add(contact);
                        });
                      }
                      _phoneController.clear();
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: ListView.builder(
                  itemCount: contacts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: Card(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text('${contacts[index]}'),
                                ),
                                Flexible(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          contacts.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        size: 20,
                                        color: Colors.blue,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    address = value;
                  },
                  controller: addressController,
                  decoration: const InputDecoration(
                    hintText: 'Address',
                    labelText: 'Address',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    district = value;
                  },
                  controller: districtController,
                  decoration: const InputDecoration(
                    hintText: 'district',
                    labelText: 'district',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    state = value;
                  },
                  controller: stateController,
                  decoration: const InputDecoration(
                    hintText: 'State',
                    labelText: 'State',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    pincode = value;
                  },
                  controller: pinController,
                  decoration: const InputDecoration(
                    hintText: 'Pincode',
                    labelText: 'Pincode',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    locality = value;
                  },
                  controller: localityController,
                  decoration: const InputDecoration(
                    hintText: 'Locality',
                    labelText: 'Locality',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    jobBranch = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Job Branch',
                    labelText: 'Job Branch',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    loanAcNo = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Loan Account Number',
                    labelText: 'Loan Account Number',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    dropdownColor: Colors.white,
                    value: purpose == null ? null : purposes[purpose],
                    underline: Container(
                      height: 0,
                    ),
                    items: purposes
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        purpose = purposes.indexOf(value.toString());
                        purposeOfValuation = value.toString();
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    instructions = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Instructions',
                    labelText: 'Instructions',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                    log(selectedDate.toString());
                    if (lati.isEmpty) {
                      const snackBar = SnackBar(
                          content: Text('Please enter a valid location'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    } else if (propertyType.isEmpty) {
                      const snackBar = SnackBar(
                          content: Text('Please enter a valid property type'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    } else if (propertyType == 'Select a Property Type') {
                      final snackBar = SnackBar(
                          content: Text('Please enter a valid property type'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    caseMap = {
                      'bankName': bankName,
                      'bankBranchName': bankBranchName,
                      'bankEmployeeName': bankEmployeeName,
                      'address': address,
                      'borrowerNames': borrowerNames,
                      'caseStatus': 'Not Assigned',
                      'contactNo': contacts,
                      'dateOfInspection': date,
                      'district': district,
                      'instructions': instructions,
                      'jobBranch': jobBranch,
                      'latitude': double.parse(lati),
                      'loanAcNo': loanAcNo,
                      'locality': localityController.text,
                      'longitude': double.parse(longi),
                      'pincode': pincode,
                      'purposeOfValuation': purposeOfValuation,
                      'state': state,
                      'typeOfAsset': propertyType
                    };
                    createNewCase();

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
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget returnBankDropDown() {
    if (bankName != '') {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Banks').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            final messages = snapshot.data!.docs;
            bankBranchNames.clear();
            for (var message in messages) {
              if (message.get('bankName') == bankName) {
                bankBranchNames.add(message.get('bankBranchName'));
              }
            }
            return Padding(
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
                    value: branch == null ? null : bankBranchNames[branch],
                    underline: Container(
                      height: 0,
                    ),
                    items: bankBranchNames
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
                        branch = bankBranchNames.indexOf(value.toString());
                        bankBranchName = value.toString();
                      });
                    },
                  ),
                ),
              ),
            );
          });
    } else
      return SizedBox();
  }

  Widget returnEmployeeDown() {
    if (bankBranchName != '') {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Banks').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            final messages = snapshot.data!.docs;
            bankEmployeeNames.clear();
            Map amap = {};
            List list = [];
            for (var message in messages) {
              if (message.get('bankName') == bankName &&
                  message.get('bankBranchName') == bankBranchName) {
                // bankEmployeeNames.add(message.get('bankEmployeeName'));
                list = message.get('employeeInfo');
                //print(list);
              }
            }
            for (int i = 0; i < list.length; i++) {
              amap.addAll(list[i]);
              bankEmployeeNames.add(amap['empName']);
            }
            if (bankEmployeeNames.isNotEmpty) {
              return Padding(
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
                          employee == null ? null : bankEmployeeNames[employee],
                      underline: Container(
                        height: 0,
                      ),
                      items: bankEmployeeNames
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
                          employee =
                              bankEmployeeNames.indexOf(value.toString());
                          bankEmployeeName = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          });
    } else {
      return const SizedBox();
    }
  }
}
