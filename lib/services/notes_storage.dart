import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes/models/note.dart';

class NotesStorage {
  saveNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(note.generateID(), json.encode(note.toJSON()));
    print("saved");
  }

  Future<Map<String, dynamic>> getNote(String noteID) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(noteID));
  }

  removeNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(note.generateID());
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> out = [];
    for (String noteID in prefs.getKeys()) {
      Map<String, dynamic> noteData = await getNote(noteID);
      out.add(noteData);
    }
    return out;
  }
}
