import 'package:flutter/material.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';
import 'package:aml/stores/album_store.dart';
import '../access_info/app_access_info.dart';
import 'custom_date_picker.dart';
import 'input_field.dart';

class AlbumInfo extends StatefulWidget {
  const AlbumInfo({Key? key, required this.bodyData}) : super(key: key);
  final Map<String, String> bodyData;

  @override
  State<AlbumInfo> createState() => _AlbumInfoState();
}

class _AlbumInfoState extends State<AlbumInfo> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController titleInput = TextEditingController();
  TextEditingController artistInput = TextEditingController();
  TextEditingController groupInput = TextEditingController();
  TextEditingController albumArtInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateInput.text = widget.bodyData['released'].toString();
    titleInput.text = widget.bodyData['title'].toString();
    artistInput.text = widget.bodyData['artist'].toString();
    groupInput.text = widget.bodyData['artistGroup'].toString();
    albumArtInput.text = widget.bodyData['albumArt'].toString();
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
        title: Text('앨범 정보'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  titleInput.text,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Divider(indent: 20, endIndent: 20, thickness: 2,),
              SizedBox(
                  child: Center(
                      child: Image.network(albumArtInput.text,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(defaultAlbumArtUrl, width: 300, height: 300, fit: BoxFit.cover,);
                        },
                      )
                  )
              ),
              SizedBox(
                child: Column(
                  children: [
                    DatePicker(dateInput: dateInput, enabled: context.read<MainStore>().loginStatus),
                    InputField(inputData: titleInput, type: 'title', enabled: context.read<MainStore>().loginStatus),
                    InputField(inputData: artistInput, type: 'artist', enabled: context.read<MainStore>().loginStatus),
                    InputField(inputData: groupInput, type: 'group', enabled: context.read<MainStore>().loginStatus),
                    InputField(inputData: albumArtInput, type: 'albumArt', enabled: context.read<MainStore>().loginStatus),
                  ],
                ),
              ),
              context.read<MainStore>().loginStatus ?
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Map<String, String> bodyData = {
                            'id' : widget.bodyData['id'].toString(),
                            'released' : dateInput.text,
                            'title' : titleInput.text,
                            'artist' : artistInput.text,
                            'artistGroup' : groupInput.text,
                            'albumArt' : albumArtInput.text,
                          };
                          context.read<AlbumStore>().postAlbum(bodyData, 'update');
                          Navigator.pop(context);
                          CustomSnackbar.snackbar(context, '앨범 정보가 수정되었습니다.', 'normal');
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

                          var result = showDialog(context: context, builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            content: SizedBox(
                              height: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '정말 삭제하시겠습니까?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.redAccent
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                                            ),
                                            child: Text('삭제'),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text('취소'),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                          print(result);


                          // context.read<AlbumStore>().postAlbum(widget.bodyData, 'delete');
                          // Navigator.pop(context);
                          // CustomSnackbar.snackbar(context, '앨범 정보가 삭제되었습니다.', 'normal');
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
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

