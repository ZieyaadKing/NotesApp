import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NoteCard extends StatelessWidget {
  final Note? note;

  const NoteCard({this.note});

  @override
  Widget build(BuildContext context) {
    Color fontColor = note!.color == Colors.white ? Colors.black : Colors.white;

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: note!.color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note!.title!,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: fontColor)),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: Text(
              note!.body!,
              style: TextStyle(color: fontColor),
            ),
          ),
          Spacer(),
          Text(_handleTimestamp(),
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 12, color: fontColor))
        ],
      ),
    );
  }

  bool isTodaysDate(DateTime timestamp) {
    DateTime todaysDate = DateTime.now();
    return (timestamp.day == todaysDate.day &&
        timestamp.month == todaysDate.month &&
        timestamp.year == todaysDate.year);
  }

  String _handleTimestamp() {
    if (isTodaysDate(note!.modifiedTimestamp!)) {
      int seconds = note!.modifiedTimestamp!.second;
      int minutes = note!.modifiedTimestamp!.minute;
      int hours = note!.modifiedTimestamp!.hour;
      return "$hours:$minutes:$seconds";
    }
    int day = note!.modifiedTimestamp!.day;
    int month = note!.modifiedTimestamp!.month;
    int year = note!.modifiedTimestamp!.year;
    return "$day " + getMonthName(month)! + " $year";
  }

  String? getMonthName(int month) {
    Map<int, String> monthNames = {
      1: "January",
      2: "February",
      3: "March",
      4: "April",
      5: "May",
      6: "June",
      7: "July",
      8: "August",
      9: "September",
      10: "October",
      11: "November",
      12: "December"
    };
    return monthNames[month];
  }
}
