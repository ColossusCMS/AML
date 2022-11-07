import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:aml/stores/album_store.dart';
import '../access_info/app_access_info.dart';
import '../components/custom_alert.dart';
import '../components/custom_date_picker.dart';
import '../components/input_field.dart';
import '../stores/main_store.dart';

class AlbumEntry extends StatefulWidget {
  const AlbumEntry({Key? key, this.pageController}) : super(key: key);
  final pageController;

  @override
  State<AlbumEntry> createState() => _AlbumEntryState();
}

class _AlbumEntryState extends State<AlbumEntry> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController titleInput = TextEditingController();
  TextEditingController artistInput = TextEditingController();
  TextEditingController groupInput = TextEditingController();
  TextEditingController albumArtInput = TextEditingController();
  bool _imgFieldEnabled = true;
  var _selectedImage;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initText();
    super.initState();
  }

  initText() {
    setState(() {
      dateInput.text = '';
      titleInput.text = '';
      artistInput.text = '';
      groupInput.text = '';
      _imgReset();
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
            builder: (context) => CustomAlert(title: '이미지는 10MB이하만 가능합니다.')
        );
      }
      if (context.read<MainStore>().imgValidateCheck(fileName) == false) {
        print('이미지 파일이 아님');
        return;
      }
      setState(() {
        _selectedImage = File(imageFile.files.single.path.toString());
        String fileName = imageFile.files.single.name;
        print(fileName);
        albumArtInput.text = '$albumArtUrl/$fileName';
        _imgFieldEnabled = false;
      });
    }
    return;
  }

  _imgReset() {
    setState(() {
      _selectedImage = null;
      _imgFieldEnabled = true;
      albumArtInput.text = '';
    });
  }

  addAlbumData(bodyData) async {
    if(!await context.read<AlbumStore>().submit(bodyData)) {
      print('HTTP 통신에서 오류가 발생했습니다.');
      return false;
    }

    if(_selectedImage != null) {
      // await albumArtUpload();
      await context.read<AlbumStore>().albumArtUpload(_selectedImage);
      print('로컬에서 선택한 이미지 있음');
    } else {
      print('로컬에서 선택한 이미지 없음');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 3, color: Colors.deepPurple),
        ),
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(3),
                        child: IconButton(
                          onPressed: () {
                            _pickImg();
                          },
                          icon: DottedBorder(
                            color: Colors.grey,
                            dashPattern: [5, 3],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(5),
                            child: _selectedImage == null
                                ? Center(child: Icon(Icons.add_a_photo, size: 50,),)
                                : Image.file(_selectedImage, fit: BoxFit.cover, width: 300, height: 300,),
                          ),
                        ),
                      ),
                      _selectedImage != null ? TextButton(
                        child: Text('이미지 선택 해제'),
                        onPressed: () {
                          _imgReset();
                        },
                      ) : SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                DatePicker(dateInput: dateInput,),
                InputField(inputData: titleInput, type: 'title', enabled: true),
                InputField(inputData: artistInput, type: 'artist', enabled: true),
                InputField(inputData: groupInput, type: 'group', enabled: true),
                InputField(inputData: albumArtInput, type: 'albumArt', enabled: _imgFieldEnabled,),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                          onPressed: () {
                            initText();
                          },
                          child: Text('초기화'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                            onPressed: () async {
                              if(albumArtInput.text == '') {
                                albumArtInput.text = defaultAlbumArtUrl;
                              }
                              Map<String, String> bodyData = {
                                'released' : dateInput.text,
                                'title' : titleInput.text,
                                'artist' : artistInput.text,
                                'artistGroup' : groupInput.text,
                                'albumArt' : albumArtInput.text
                              };
                              if(formKey.currentState!.validate()) {
                                if(!await addAlbumData(bodyData)) {
                                  CustomSnackbar.snackbar(context, '앨범 정보 등록 실패', 'warning');
                                  print('데이터 등록 실패');
                                  return;
                                }
                                CustomSnackbar.snackbar(context, '앨범 정보 등록 성공', 'normal');
                                print('데이터 등록 성공');
                                initText();
                                FocusScope.of(context).unfocus();
                                widget.pageController(0);
                              }
                            },
                            child: Text('저장하기')
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
