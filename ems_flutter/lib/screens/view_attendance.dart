import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("View attendance"),
    );
  }
}
