
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fname = '',
      email = '',
      phone1 = '',
      phone2 = '',
      address = '',
      district = '',
      latitude = '',
      locality = '',
      longitude = '',
      pincode = '',
      maritalStatus = '',
      birthday = '',
      aadharNo = '',
      religion = '',
      state = '';
  late TextEditingController
  namecontroller = TextEditingController(text: fname),
      emailcontroller = TextEditingController(text: email),
      phn1cont = TextEditingController(text: phone1),
      phn2cont = TextEditingController(text: phone2),
      aadharcont = TextEditingController(text: aadharNo),
      birthcont = TextEditingController(text: birthday),
      maritalcont = TextEditingController(text: maritalStatus),
      religioncont = TextEditingController(text: religion),
      addresscont = TextEditingController(text: address),
      statecont = TextEditingController(text: state),
      pincont = TextEditingController(text: pincode),
      localcont = TextEditingController(text: locality),
      distcont = TextEditingController(text: district);

  late Map<String, dynamic> map = {};
  late Map<String, dynamic> addressmap = {};
  late Map<String, dynamic> personalInfoMap = {};
  void updateProfile() async {
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(map);
    var address = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Address information')
        .doc('address_info');
    address.set(addressmap);
    var personal = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Personal information')
        .doc('personal_info');
    personal.set(personalInfoMap);
  }

  void getProfileData() async {
    await for (var snapshot
    in FirebaseFirestore.instance.collection('Users').snapshots()) {
      for (var message in snapshot.docs) {}
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data!.docs;
          for (var message in messages) {
            if (message.get('email') ==
                FirebaseAuth.instance.currentUser!.email) {
              fname = message.get('name');
              email = message.get('email');
              List contact = message.get('contactNo');
              if(contact.length>1)
              {
                phone2 = contact[1];
              }
              phone1 = contact[0] ;

            }
          }
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Property Evaluation'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: namecontroller,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          fname = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Name',
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
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: emailcontroller,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email',
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
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: phn1cont,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phone1 = value;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Phone',
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
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: phn2cont,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onChanged: (value) {
                          phone2 = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Phone 2',
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
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Address information')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          );
                        }
                        final messages = snapshot.data!.docs;

                        for (var message in messages) {
                          address = message.get('address');
                          state = message.get('state');
                          pincode = message.get('pincode');
                          district = message.get('district');
                          latitude = message.get('latitude');
                          locality = message.get('locality');
                          longitude = message.get('longitude');

                        }

                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: addresscont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        address = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
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
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: distcont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        district = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'District',
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
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: localcont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        locality = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Locality',
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
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: statecont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        state = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'State',
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
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: pincont,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        pincode = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Pincode',
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
                            ],
                          ),
                        );
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Personal information')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          );
                        }
                        final messages = snapshot.data!.docs;
                        for (var message in messages) {
                          aadharNo = message.get('aadharNo');
                          Timestamp birth = message.get('dateOfBirth');
                          maritalStatus = message.get('maritalStatus');
                          religion = message.get('religion');
                          var date = DateTime.fromMicrosecondsSinceEpoch(birth.microsecondsSinceEpoch);
                          birthday = date.year.toString()+'-'+ date.month.toString()+'-'+ date.day.toString();
                        }
                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: maritalcont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        maritalStatus = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Marital Status',
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
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: birthcont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        birthday = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Birthdate',
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
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: aadharcont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        aadharNo = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Aadhar No',
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
                                padding:
                                const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: religioncont,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      setState(() {
                                        religion = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Religion',
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
                            ],
                          ),
                        );
                      }),
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
                          bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          fname=namecontroller.value.text;
                          email=emailcontroller.value.text;
                          phone1=phn1cont.value.text;
                          phone2=phn2cont.value.text;
                          address=addresscont.value.text;
                          district=distcont.value.text;
                          locality=localcont.value.text;
                          state=statecont.value.text;
                          pincode=pincont.value.text;
                          maritalStatus=maritalcont.value.text;
                          birthday=birthcont.value.text;
                          aadharNo=aadharcont.value.text;
                          religion=religioncont.value.text;
                          var contaact = {phone1, phone2} ;
                          DateTime somedate = DateTime.parse(birthday+' 00:00:00');
                          Timestamp datee = Timestamp.fromMicrosecondsSinceEpoch(somedate.microsecondsSinceEpoch);
                          print(datee.toString());
                          if (namecontroller.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid Name'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (emailcontroller.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid Email'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (!emailValid) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid email ID'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (phn1cont.value.text == '') {
                            const snackBar = SnackBar(
                                content:
                                Text('Please enter a valid phone number'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (phn2cont.value.text == '') {
                            const snackBar = SnackBar(
                                content:
                                Text('Please enter a valid phone number'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (addresscont.value.text == '') {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid address'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (distcont.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid district'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (localcont.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid locality'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (pincont.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid pincode'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (statecont.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid state'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (birthcont.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text('Please enter a valid age'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (maritalcont.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content: Text(
                                    'Please enter a valid Marital Status'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else if (aadharcont.value.text.isEmpty) {
                            const snackBar = SnackBar(
                                content:
                                Text('Please enter a valid aadhar number'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          } else {
                            print(phone1);
                            map = {
                              'name': fname,
                              'email': email,
                              'contact': contaact,
                              'typeOfUser': 'Field Visit Officer'
                            };
                            addressmap = {
                              'address': address,
                              'district': district,
                              'latitude': latitude,
                              'locality': locality,
                              'longitude': longitude,
                              'pincode': pincode,
                              'state': state
                            };
                            personalInfoMap = {
                              'maritalStatus': maritalStatus,
                              'dateOfBirth': datee,
                              'religion': religion,
                              'aadharNo': aadharNo
                            };
                            updateProfile();
                            const snackBar = SnackBar(
                              content: Text('Submitted Successfully!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Dashboard(),
                              ),
                            );
                            return;
                          }
                        },
                        child: const Text(
                          "Submit",
                          style:
                          TextStyle(fontSize: 18, fontFamily: "BonaNova"),
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
          );
        });
  }
}
