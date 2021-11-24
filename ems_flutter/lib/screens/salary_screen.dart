import 'package:emsflutter/resources/AppColors.dart';
import 'package:emsflutter/screens/view_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({Key? key}) : super(key: key);

  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {

  final empIdController = TextEditingController();
  String startDate =
  DateFormat('EEE MMM d yyyy').format(DateTime.now()).toString();
  String endDate =
  DateFormat('EEE MMM d yyyy').format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            "Calculate Salary",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
            child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                color: Colors.white,
                height: double.infinity,
                child: Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 1, color: AppColors.PRIMARY),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Please enter details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.PRIMARY),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: AppColors.TEXT_INPUT_BORDER))),
                            child: TextField(
                              controller: empIdController,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                  hintText: "Employee ID",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6)),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text("For the period"),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "From",
                            style: TextStyle(color: AppColors.TEXT_GREY),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    width: 1, color: AppColors.IMAGE_BORDER)),
                            child: InkWell(
                                onTap: () async {
                                  await DatePicker.showSimpleDatePicker(
                                    context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1960),
                                    lastDate: DateTime(3000),
                                    dateFormat: "dd-MMMM-yyyy",
                                    locale: DateTimePickerLocale.en_us,
                                    looping: true,
                                  ).then((date) => {
                                    setState(() {
                                      DateFormat formatter =
                                      DateFormat('EEE MMM d yyyy');
                                      String formatted =
                                      formatter.format(date!);
                                      startDate = formatted;
                                    })
                                  });
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(startDate),
                                )),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "To",
                            style: TextStyle(color: AppColors.TEXT_GREY),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    width: 1, color: AppColors.IMAGE_BORDER)),
                            child: InkWell(
                                onTap: () async {
                                  await DatePicker.showSimpleDatePicker(
                                    context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1960),
                                    lastDate: DateTime(3000),
                                    dateFormat: "dd-MMMM-yyyy",
                                    locale: DateTimePickerLocale.en_us,
                                    looping: true,
                                  ).then((date) => {
                                    setState(() {
                                      DateFormat formatter =
                                      DateFormat('EEE MMM d yyyy');
                                      String formatted =
                                      formatter.format(date!);
                                      endDate = formatted;
                                    })
                                  });
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(endDate),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => onButtonPress(
                                    empIdController.text, startDate, endDate),
                                child: const Text("View Attendance"),
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      AppColors.BUTTON),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  onButtonPress(String empId, String startDate, String endDate) {
    if (empId.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter employee ID");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewAttendance(
              empId: empId,
              startDate: startDate,
              endDate: endDate,
            ),
          ));
    }
  }
}
