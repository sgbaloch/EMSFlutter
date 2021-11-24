import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emsflutter/resources/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewAttendance extends StatefulWidget {
  final String empId, startDate, endDate;
  const ViewAttendance(
      {Key? key,
      required this.empId,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  List<QueryDocumentSnapshot> attendanceData = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            "View Attendance",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.IMAGE_BORDER, width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: Image.asset('assets/images/employee.png',
                          width: 44, height: 44),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: getEmployeeName(widget.empId),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> text) {
                            return Text(
                              text.data.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        FutureBuilder(
                          future: getEmployeeDesignation(widget.empId),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> text) {
                            return Text(
                              text.data.toString(),
                            );
                          },
                        ),
                      ],
                    ),
                    Expanded(
                        child: Text(
                      "Emp Id: " + widget.empId,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "For the period: " +
                          changeDateFormat(widget.startDate, 'yMd') +
                          " - " +
                          changeDateFormat(widget.endDate, 'yMd'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))
                  ],
                ),
                FutureBuilder(
                    future: initializeFirebaseApp(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error! Something went wrong");
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("attendance")
                                .where('timeIn',
                                    isGreaterThanOrEqualTo:
                                        strDateToTimeStamp(widget.startDate))
                                .where('timeIn',
                                    isLessThanOrEqualTo:
                                        strDateToTimeStamp(widget.endDate))
                                .where('empId',
                                    isEqualTo: int.parse(widget.empId))
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text(
                                    "Error! Something went wrong");
                              } else if (snapshot.hasData ||
                                  snapshot.data != null) {
                                attendanceData = snapshot.data!.docs;
                                return Container(
                                  padding: const EdgeInsets.all(2),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length + 2,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                          color: AppColors.PRIMARY,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Date',
                                                    style: headerTextStyle,
                                                    textAlign: TextAlign.center,
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Time In',
                                                    style: headerTextStyle,
                                                    textAlign: TextAlign.center,
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Time Out',
                                                    style: headerTextStyle,
                                                    textAlign: TextAlign.center,
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Hours',
                                                    style: headerTextStyle,
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ],
                                          ),
                                        );
                                      }

                                      if (index ==
                                          snapshot.data!.docs.length + 1) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            border: Border.symmetric(horizontal: BorderSide(width: 1))
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    'Total Hours Worked',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    getTotalHours(
                                                        attendanceData),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                            ],
                                          ),
                                        );
                                      }

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  timeStampToDateString(snapshot
                                                      .data!.docs[index - 1]
                                                      .get("timeIn")),
                                                  style: listTextStyle,
                                                  textAlign: TextAlign.center,
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    timeStampToTimeString(
                                                        snapshot.data!
                                                            .docs[index - 1]
                                                            .get("timeIn")),
                                                    style: listTextStyle,
                                                    textAlign:
                                                        TextAlign.center)),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  timeStampToTimeString(snapshot
                                                      .data!.docs[index - 1]
                                                      .get("timeOut")),
                                                  style: listTextStyle,
                                                  textAlign: TextAlign.center,
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  getHoursWorked(
                                                      snapshot
                                                          .data!.docs[index - 1]
                                                          .get("timeIn"),
                                                      snapshot
                                                          .data!.docs[index - 1]
                                                          .get("timeOut")),
                                                  style: listTextStyle,
                                                  textAlign: TextAlign.center,
                                                )),
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
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  String changeDateFormat(String strDate, String strFormat) {
    DateTime dateTime = DateFormat('EEE MMM d yyyy').parse(strDate);

    return DateFormat(strFormat).format(dateTime).toString();
  }

  Future<String> getEmployeeName(String empId) async {
    String name = '';
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(empId)
        .get()
        .then((data) => {
              if (data.exists)
                {name = data.get("firstName") + " " + data.get("lastName")}
              else
                {}
            });

    return name;
  }

  Future<String> getEmployeeDesignation(String empId) async {
    String designation = '';
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(empId)
        .get()
        .then((data) => {
              if (data.exists) {designation = data.get("designation")} else {}
            });

    return designation;
  }

  Future<FirebaseApp> initializeFirebaseApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Timestamp strDateToTimeStamp(String date) {
    DateTime dateTime = DateFormat('EEE MMM d yyyy').parse(date);
    return Timestamp.fromDate(dateTime);
  }

  String timeStampToDateString(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yMd').format(dateTime);
  }

  String timeStampToTimeString(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.Hm().format(dateTime);
  }

  String getHoursWorked(Timestamp timeIn, Timestamp timeOut) {
    var hours = formatDuration(timeOut.toDate().difference(timeIn.toDate()));
    return hours;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  String getTotalHours(List<QueryDocumentSnapshot> list) {
    var totalHours = 0.0;

    for (var element in list) {
      Timestamp timeIn = element.get('timeIn');
      Timestamp timeOut = element.get('timeOut');
      var hours =
          timeOut.toDate().difference(timeIn.toDate()).inMilliseconds / 3600000;
      totalHours = totalHours + hours;
    }

    var hourStr = totalHours.floor().toString();
    var minuteStr = ((totalHours % 1) * 60).round().toString();

    if (hourStr.length < 2) {
      hourStr = '0' + hourStr;
    }

    if (minuteStr.length < 2) {
      minuteStr = "0" + minuteStr;
    }

    return hourStr + ':' + minuteStr;
  }

  TextStyle listTextStyle = const TextStyle(fontSize: 12);
  TextStyle headerTextStyle =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

//  snapshot
//      .data!.docs[index - 1]
//      .get("timeIn")
}
