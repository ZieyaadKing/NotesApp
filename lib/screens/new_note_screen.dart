import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NewNoteScreen extends StatefulWidget {
  final Note? editNote;

  NewNoteScreen({this.editNote});
  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  TextEditingController? _titleEditController;
  TextEditingController? _bodyEditController;
  String? _tempTitle = "";
  String? _tempBody = "";

  List<Color> possibleBackgrounds = [
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.amber,
  ];
  int colorIndex = 1;
  Color background = Colors.white;
  Color textColor = Colors.black;

  void _setTempTitle(String _title) => setState(() => _tempTitle = _title);
  void _setTempBody(String _body) => setState(() => _tempBody = _body);

  Note? createNote(String title, String? body) {
    if (title.length == 0 && body!.length == 0) return null;
    return new Note(
        title: title,
        body: body,
        modifiedTimestamp: DateTime.now(),
        color: background);
  }

  void changeBackground() {
    colorIndex = (colorIndex + 1) % possibleBackgrounds.length;
    setState(() {
      background = possibleBackgrounds[colorIndex];
      textColor = background == Colors.white || background == Colors.amber
          ? Colors.black
          : Colors.white;
    });
  }

  @override
  void initState() {
    if (widget.editNote != null) {
      _tempTitle = widget.editNote!.title;
      _tempBody = widget.editNote!.body;
      _titleEditController = TextEditingController(text: _tempTitle);
      _bodyEditController = TextEditingController(text: _tempBody);
      background = widget.editNote!.color!;
      textColor =
          widget.editNote!.color == Colors.white ? Colors.black : Colors.white;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context)
        .textTheme
        .headline2!
        .copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: textColor);
    TextStyle bodyStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontSize: 20, color: textColor);

    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: textColor),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                icon: Icon(Icons.refresh, color: textColor),
                onPressed: changeBackground),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.save, color: textColor),
              onPressed: () =>
                  Navigator.of(context).pop(createNote(_tempTitle!, _tempBody)),
            ),
            SizedBox(width: 20),
          ],
          elevation: 0.0,
        ),
        backgroundColor: background,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // SizedBox(height: 20),
              TextField(
                autocorrect: true,
                controller: _titleEditController,
                decoration: InputDecoration.collapsed(
                  hintText: "Title",
                  hintStyle: titleStyle,
                ),
                onChanged: (String _title) => _setTempTitle(_title),
                style: titleStyle,
              ),
              SizedBox(height: 20),
              TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration.collapsed(hintText: ""),
                controller: _bodyEditController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (String _body) => _setTempBody(_body),
                style: bodyStyle,
              )
            ],
          ),
        ));
  }
}
