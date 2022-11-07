import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({Key? key, this.inputData, this.type, this.enabled}) : super(key: key);
  final inputData;
  final type;
  final enabled;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final Map<String, List<dynamic>> _contents = {
    'album': ['앨범명', Icon(Icons.album)],
    'artist': ['가수', Icon(Icons.mic)],
    'group': ['소속', Icon(Icons.group)],
    'albumArt': ['앨범아트', Icon(Icons.image)],
    'title': ['제목', Icon(Icons.title)],
    'path': ['경로', Icon(Icons.folder)],
    'ext': ['포맷', Icon(Icons.file_copy)]
  };

  @override
  Widget build(BuildContext context) {
    List list = _contents[widget.type]!;

    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: TextFormField(
        validator: (val) {
          if(val == null || val.isEmpty) {
            return '* ${list[0]}을(를) 입력해야 합니다.';
          }
        },
        controller: widget.inputData,
        decoration: InputDecoration(
          icon: list[1],
          labelText: list[0],
          filled: true,
          fillColor: Colors.white70,
        ),
        // enabled: widget.enabled,
        readOnly: !widget.enabled,
      ),
    );
  }
}