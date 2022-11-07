import 'dart:io';

import 'package:aml/components/custom_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:provider/provider.dart';
import '../access_info/app_access_info.dart';
import '../constaints.dart';
import '/stores/main_store.dart';
import '/stores/album_store.dart';
import '/components/custom_date_picker.dart';
import '/components/input_field.dart';

class InfoBox extends StatefulWidget {
  const InfoBox({Key? key, required this.data, required this.type}) : super(key: key);
  final Map<String, String> data;
  final type;

  @override
  State<InfoBox> createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  final formKey = GlobalKey<FormState>();
  var _pageTitle;
  var _infoInputBox;
  var _selectedImage;
  var originAlbumArtPath;
  Map<String, TextEditingController> mapController = {
    'dateInputController' : TextEditingController(),
    'titleInputController' : TextEditingController(),
    'artistInputController' : TextEditingController(),
    'groupInputController' : TextEditingController(),
    'albumInputController' : TextEditingController(),
    'albumArtInputController' : TextEditingController(),
    'pathInputController' : TextEditingController(),
    'extInputController' : TextEditingController(),
  };

  @override
  initState() {
    super.initState();
    originAlbumArtPath = widget.data['albumArt'];
    setType();
  }

  setType() {
    setState(() {
      switch(widget.type) {
        case 'A':
          _pageTitle = '앨범 상세정보';
          _infoInputBox = AlubmInfoInputBox(data: widget.data, controllerData: mapController, formKey: formKey,);
          break;
        case 'M':
          _pageTitle = '음악 상세정보';
          _infoInputBox = MusicInfoInputBox(data: widget.data, controllerData: mapController);
          break;
        case 'L':
          _pageTitle = '가사';
      }
    });
  }

  _pickImg() async {
    FilePickerResult? imageFile = await FilePicker.platform.pickFiles();
    if(imageFile != null) {
      int fileSize = imageFile.files.single.size;
      String fileName = imageFile.files.single.name;
      if(fileSize > 10500000) {
        return showDialog(
            context: context,
            builder: (context) => CustomAlert(title: '이미지는 10MB이하만 가능합니다.',)
        );
      }
      if(context.read<MainStore>().imgValidateCheck(fileName) == false) {
        print('이미지 파일이 아님');
        return;
      }
      setState(() {
        _selectedImage = File(imageFile.files.single.path.toString());
        String fileName = imageFile.files.single.name;
        print(fileName);
        TextEditingController albumArtController = TextEditingController();
        albumArtController.text = '$albumArtUrl/$fileName';
        mapController['albumArtInputController'] = albumArtController;
      });
    }
  }

  _imgReset() {
    setState(() {
      _selectedImage = null;
      TextEditingController albumArtController = TextEditingController();
      albumArtController.text = originAlbumArtPath;
      mapController['albumArtInputController'] = albumArtController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_outlined),
        ),
        title: Text(_pageTitle),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: infoBoxBorderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              (widget.type == 'A' || widget.type == 'L') ? Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.data['title'].toString(), style: TextStyle(fontSize: infoTitleFontSize, fontWeight: FontWeight.bold),),
                  ),
                  Divider(indent: 20, endIndent: 20, thickness: 2,),
                  Visibility(
                      visible: widget.type == 'L',
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Center(
                          child: Text(widget.data['artist'].toString()),
                        ),
                      )
                  )
                ],
              ) : SizedBox(),
              Visibility(
                visible: (widget.type != 'L'),
                child: Column(
                  children: [
                    SizedBox(
                      child: Center(
                        child: _selectedImage == null
                            ? Image.network(
                          widget.data['albumArt'].toString(),
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              defaultAlbumArtUrl,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                            : Image.file(_selectedImage, fit: BoxFit.cover, width: 300, height: 300,),
                      ),
                    ),
                    _selectedImage == null
                        ? TextButton(
                        onPressed: () {
                          _pickImg();
                        },
                        child: Text('이미지 선택')
                    )
                        : TextButton(
                        onPressed: () {
                          _imgReset();
                        },
                        child: Text('이미지 선택 취소')
                    )
                  ],
                ),
              ),
              (widget.type != 'L') ? SizedBox(
                child: _infoInputBox,
              ) : Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Text(widget.data['lyrics'].toString(), style: TextStyle(fontSize: 18.0, height: 1.6, fontWeight: FontWeight.bold),),
              ),
              (widget.type == 'A')
                  ? ControlButtonBox(data: widget.data, controllerData: mapController, formKey: formKey, selectedImage: _selectedImage,)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class AlubmInfoInputBox extends StatefulWidget {
  const AlubmInfoInputBox({Key? key, required this.data, required this.controllerData, required this.formKey}) : super(key: key);
  final Map<String, String> data;
  final Map<String, TextEditingController> controllerData;
  final formKey;

  @override
  State<AlubmInfoInputBox> createState() => _AlubmInfoInputBoxState();
}

class _AlubmInfoInputBoxState extends State<AlubmInfoInputBox> {
  late Map<String, TextEditingController> mapData;

  @override
  void initState() {
    super.initState();
    mapData = widget.controllerData;

    mapData['dateInputController']?.text = widget.data['released'].toString();
    mapData['titleInputController']?.text = widget.data['title'].toString();
    mapData['artistInputController']?.text = widget.data['artist'].toString();
    mapData['groupInputController']?.text = widget.data['artistGroup'].toString();
    mapData['albumArtInputController']?.text = widget.data['albumArt'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          DatePicker(
            dateInput: mapData['dateInputController'],
            enabled: context.read<MainStore>().loginStatus,
          ),
          InputField(
            inputData: mapData['titleInputController'],
            type: 'album',
            enabled: context.read<MainStore>().loginStatus,
          ),
          InputField(
            inputData: mapData['artistInputController'],
            type: 'artist',
            enabled: context.read<MainStore>().loginStatus,
          ),
          InputField(
            inputData: mapData['groupInputController'],
            type: 'group',
            enabled: context.read<MainStore>().loginStatus,
          ),
          InputField(
            inputData: mapData['albumArtInputController'],
            type: 'albumArt',
            enabled: context.read<MainStore>().loginStatus,
          ),
        ],
      ),
    );
  }
}

class MusicInfoInputBox extends StatefulWidget {
  const MusicInfoInputBox({Key? key, required this.data, required this.controllerData}) : super(key: key);
  final Map<String, String> data;
  final Map<String, TextEditingController> controllerData;

  @override
  State<MusicInfoInputBox> createState() => _MusicInfoInputBoxState();
}

class _MusicInfoInputBoxState extends State<MusicInfoInputBox> {
  late Map<String, TextEditingController> mapData;

  @override
  initState() {
    super.initState();
    mapData = widget.controllerData;

    mapData['titleInputController']?.text = widget.data['title'].toString();
    mapData['artistInputController']?.text = widget.data['artist'].toString();
    mapData['albumInputController']?.text = widget.data['album'].toString();
    mapData['pathInputController']?.text = widget.data['path'].toString();
    mapData['extInputController']?.text = widget.data['ext'].toString();
    mapData['albumArtInputController']?.text = widget.data['albumArt'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          inputData: mapData['titleInputController'],
          type: 'title',
          enabled: false,
        ),
        InputField(
          inputData: mapData['artistInputController'],
          type: 'artist',
          enabled: false,
        ),
        InputField(
          inputData: mapData['albumInputController'],
          type: 'album',
          enabled: false,
        ),
        InputField(
          inputData: mapData['pathInputController'],
          type: 'path',
          enabled: false,
        ),
        InputField(
          inputData: mapData['extInputController'],
          type: 'ext',
          enabled: false,
        ),
        InputField(
          inputData: mapData['albumArtInputController'],
          type: 'albumArt',
          enabled: false,
        ),
      ],
    );
  }
}

class ControlButtonBox extends StatefulWidget {
  const ControlButtonBox({Key? key, required this.data, required this.controllerData, required this.formKey, required this.selectedImage}) : super(key: key);
  final Map<String, String> data;
  final Map<String, TextEditingController> controllerData;
  final GlobalKey<FormState> formKey;
  final selectedImage;

  @override
  State<ControlButtonBox> createState() => _ControlButtonBoxState();
}

class _ControlButtonBoxState extends State<ControlButtonBox> {
  albumArtUpload(selectedImage) async {
    var result = await context.read<AlbumStore>().albumArtUpload(selectedImage);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return context.read<MainStore>().loginStatus ?
    Container(
      margin: EdgeInsets.fromLTRB(0, 10, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
              onPressed: () async {
                if(widget.selectedImage != null) {
                  if(!await albumArtUpload(widget.selectedImage)) {
                    print('[앨범 수정]앨범아트 업로드 실패');
                    return;
                  }
                  print('[앨범 수정]앨범아트 업로드 성공');
                  FocusScope.of(context).unfocus();
                }

                Map<String, String> bodyData = {
                  'id' : widget.data['id'].toString(),
                  'released' : widget.controllerData['dateInputController']?.text ?? '',
                  'title' : widget.controllerData['titleInputController']?.text ?? '',
                  'artist' : widget.controllerData['artistInputController']?.text ?? '',
                  'artistGroup' : widget.controllerData['groupInputController']?.text ?? '',
                  'albumArt' : widget.controllerData['albumArtInputController']?.text ?? '',
                };
                if(widget.formKey.currentState!.validate()) {
                  context.read<AlbumStore>().postAlbum(bodyData, 'update');
                  Navigator.pop(context);
                  CustomSnackbar.snackbar(context, '앨범 정보가 수정되었습니다.', 'normal');
                }
              },
              icon: Icon(Icons.edit),
              label: Text('수정하기'),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(10))
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<AlbumStore>().postAlbum(widget.data, 'delete');
                Navigator.pop(context);
                CustomSnackbar.snackbar(context, '앨범 정보가 삭제되었습니다.', 'normal');
              },
              icon: Icon(Icons.delete),
              label: Text('삭제하기'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10))
              ),
            ),
          ),
        ],
      ),
    ) : SizedBox();
  }
}
