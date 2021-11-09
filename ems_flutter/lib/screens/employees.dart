import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emsflutter/Models/Employee.dart';
import 'package:emsflutter/resources/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  List<Employee> empList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<FirebaseApp> initializeFirebaseApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const BackButton(color: Colors.black),
            title: const Text("Employee List", style: TextStyle(color: Colors.black),),
          ),
          body: FutureBuilder(
              future: initializeFirebaseApp(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error! Something went wrong");
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("employees")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Error! Something went wrong");
                        } else if (snapshot.hasData || snapshot.data != null) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: AppColors.LIST_BORDER))),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.IMAGE_BORDER,
                                                width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30))),
                                        child: Image.asset(
                                            'assets/images/employee.png',
                                            width: 44,
                                            height: 44),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]
                                                .get("firstName"),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(snapshot.data!.docs[index]
                                              .get("designation"))
                                        ],
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Image.asset(
                                              'assets/images/menu.png',
                                              width: 15,
                                              height: 15,
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFF57C00),
                          ),
                        );
                      });
                }
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF57C00),
                  ),
                );
              })),
    );
  }
}
