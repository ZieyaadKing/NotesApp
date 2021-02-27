import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/components/note_card.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/notes_storage.dart';

import 'new_note_screen.dart';

class MyHomePage extends StatefulWidget {
  final NotesStorage storage = new NotesStorage();

  MyHomePage({Key? key}) : super(key: key);

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> notes = [
    new Note(
        body: "This is just a test",
        title: "Nothing major",
        color: Colors.pink[400],
        modifiedTimestamp: DateTime.parse("2020-02-15 17:00:00")),
    new Note(
        title: "",
        color: Colors.blue[400],
        body: "Something of that nature.\nIs definitely not\nacceptable",
        modifiedTimestamp: DateTime.parse("2019-05-02 15:00:12")),
    new Note(
        title: "Oregairu",
        body:
            "To those who enjoy the lie known as youth\nGo blow yourselves up.",
        modifiedTimestamp: DateTime.parse("2012-12-03 12:01:59")),
  ];

  bool selectionState = false;
  List<Note> selectedNotes = [];

  /// --------------------- Methods for loading notes ------------- ///

  loadNotes() async {
    print("getting notes");
    try {
      List<Map<String, dynamic>> notesData = await widget.storage.getAllNotes();
      setState(() {
        notes = notesData.map((noteData) => Note.fromJSON(noteData)).toList();
      });
      print("Got notes");
    } catch (exception) {
      print(exception);
      setState(() {
        notes = [];
      });
    }
  }

  /// --------------------- Main Flutter Methods  ----------------- ///

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return selectionState ? displaySelectionMode() : displayNotesOverview();
  }

  /// ------------------  HELPER METHODS  --------------- ///

  createNewNote(BuildContext context) async {
    Note? newNote = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => new NewNoteScreen()));
    if (newNote == null) return;
    await widget.storage.saveNote(newNote);
    print(await widget.storage.getNote(newNote.generateID()));
    setState(() {
      notes.add(newNote);
    });
  }

  Scaffold displayNotesOverview() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Favourites",
            style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.blue, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        toolbarHeight: 100,
      ),
      // backgroundColor: Colors.grey[200],
      body: notes.length == 0
          ? Center(
              child: Text(
                'Waiting to see more notes from you!',
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: GridView.count(
                  semanticChildCount: notes.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    for (int i = 0; i < notes.length; i++)
                      InkWell(
                          onLongPress: () {
                            selectNote(notes[i]);
                            toggleSelectionState();
                          },
                          onTap: () => editNote(context, i),
                          child: NoteCard(note: notes[i]))
                  ]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewNote(context),
        tooltip: 'create a new note',
        elevation: 0.0,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Scaffold displaySelectionMode() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.delete, color: Colors.blue),
              onPressed: deleteSelectedNotes),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.blue),
              onPressed: toggleSelectionState),
          SizedBox(width: 10),
        ],
      ),
      // backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: InkWell(
            onTap: toggleSelectionState,
            child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  for (int i = 0; i < notes.length; i++)
                    InkWell(
                        onTap: () => selectNote(notes[i]),
                        child: Card(
                            elevation:
                                selectedNotes.contains(notes[i]) ? 10.0 : 0.0,
                            child: NoteCard(note: notes[i])))
                ]),
          ),
        ),
      ),
    );
  }

  void toggleSelectionState() {
    setState(() {
      selectionState = !selectionState;
      selectedNotes = [];
    });
  }

  void selectNote(Note note) {
    // print(selectedNotes.length);
    if (selectedNotes.contains(note)) {
      setState(() {
        selectedNotes.remove(note);
      });
      return;
    }
    setState(() {
      selectedNotes.add(note);
    });
  }

  List<BoxShadow> highlightNote(Note note) {
    return selectedNotes.contains(notes)
        ? [
            BoxShadow(
                blurRadius: 10, color: Colors.grey, offset: Offset(0, 10.0))
          ]
        : [];
  }

  void editNote(BuildContext context, int index) async {
    final Note? result = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new NewNoteScreen(editNote: notes[index])));
    if (result == null) return;
    if (result.title == notes[index].title && result.body == notes[index].body)
      return;
    setState(() {
      notes[index] = result;
    });
  }

  void removeNote(Note note) async {
    if (notes.contains(note)) {
      await widget.storage.removeNote(note);
      setState(() {
        notes.remove(note);
      });
    }
  }

  void deleteSelectedNotes() {
    setState(() {
      selectedNotes.forEach((Note note) {
        removeNote(note);
      });
    });
    selectedNotes = [];
    toggleSelectionState();
  }
}
