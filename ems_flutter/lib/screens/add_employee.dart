import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emsflutter/resources/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final firstNController = TextEditingController();
  final lastNController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final designationController = TextEditingController();
  final payController = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    disposeTextControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
              onPressed: () => {Navigator.of(context).pop()},
              color: Colors.black),
          title: const Text(
            "Add new employee",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                child: Container(
                  height: 450,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Employee Registration",
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.PRIMARY,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.only(right: 14),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: AppColors.TEXT_INPUT_BORDER))),
                            child: TextField(
                              controller: firstNController,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                  hintText: "First Name",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6)),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: AppColors.TEXT_INPUT_BORDER))),
                            child: TextField(
                              controller: lastNController,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                  hintText: "Last Name",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6)),
                            ),
                          ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: AppColors.TEXT_INPUT_BORDER))),
                        child: TextField(
                          controller: emailController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: AppColors.TEXT_INPUT_BORDER))),
                        child: TextField(
                          controller: contactController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "Contact number",
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: AppColors.TEXT_INPUT_BORDER))),
                        child: TextField(
                          controller: addressController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "Address",
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: AppColors.TEXT_INPUT_BORDER))),
                        child: TextField(
                          controller: designationController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "Designation",
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: AppColors.TEXT_INPUT_BORDER))),
                        child: TextField(
                          controller: payController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              hintText: "Hourly pay rate",
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6)),
                        ),
                      ),
                      Container(
                        height: 42.0,
                        margin: const EdgeInsets.only(top: 50),
                        child: RaisedButton(
                          onPressed: () => registerEmployee(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff4c669f),
                                    Color(0xff192f6a)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 400.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: const Text(
                                "Add employee",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
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
    );
  }

  registerEmployee() async {
    var lastDoc = firestoreInstance
        .collection("employees")
        .orderBy('dateCreated', descending: true)
        .limit(1)
        .get();

    int lastDocId = int.parse((await lastDoc).docs[0].id);
    lastDocId++;

    var timeStamp = Timestamp.fromDate(DateTime.now());

    firestoreInstance
        .collection("employees")
        .doc(lastDocId.toString())
        .set({
          'firstName': firstNController.text,
          'lastName': lastNController.text,
          'address': addressController.text,
          'email': emailController.text,
          'contact': contactController.text,
          'designation': designationController.text,
          'payRate': payController.text,
          'dateCreated': timeStamp
        })
        .then((value) =>
            Fluttertoast.showToast(msg: "Employee added successfully"))
        .catchError(
            (error) => Fluttertoast.showToast(msg: "Something went wrong!"));
  }

  void disposeTextControllers() {
    firstNController.dispose();
    lastNController.dispose();
    emailController.dispose();
    contactController.dispose();
    addressController.dispose();
    designationController.dispose();
    payController.dispose();
  }
}
