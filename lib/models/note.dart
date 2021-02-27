import 'dart:math';

import 'package:flutter/material.dart';

class Note {
  String? title;
  String? body;
  Color? color;
  DateTime? modifiedTimestamp;

  Note(
      {this.title,
      this.body,
      this.modifiedTimestamp,
      this.color = Colors.white});

  void setTitle(String title) => this.title = title;

  void setBody(String body) => this.body = body;

  void setModifiedTimestamp(DateTime timestamp) {
    modifiedTimestamp = timestamp;
  }

  String? getTitle() => title;

  String? getBody() => body;

  DateTime? getModifiedTimestamp() => modifiedTimestamp;

  String generateID() {
    return (title!.substring(0, min(title!.length, 3)) +
        body!.substring(0, min(body!.length, 3)) +
        " - " +
        modifiedTimestamp.toString());
  }

  Map<String, dynamic> toJSON() => {
        "title": title,
        "body": body,
        "modified_timestamp": modifiedTimestamp.toString(),
        "background_color": color!.value
      };

  Note.fromJSON(Map<String, dynamic> json)
      : title = json["title"],
        body = json["body"],
        modifiedTimestamp = DateTime.parse(json["modified_timestamp"]),
        color = new Color(json["background_color"]);
}
