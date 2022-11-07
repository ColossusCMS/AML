import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:aml/animation/fade_animation.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';

import '../access_info/app_access_info.dart';
import '../components/custom_alert.dart';
import '../constaints.dart';

enum Info {
  email,
  password,
  passwordChk,
  nickname,
  profileImg,
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  Color enabled = Color(0xFF927F9A);
  Color enabledTxt = Colors.white;
  Color disabled = Colors.grey;
  Color backgroundColor = Color(0xFF1F1A30);
  Info? selected;
  var _selectedImage;
  bool _imgFieldEnabled = true;

  bool _chkEmail = false;  //이메일 확인 메시지용
  bool _chkSameEmail = false; //이미 등록된 이메일인지 체크
  bool _isShowPassword = true;    //비밀번호 보여주기/숨기기
  bool _isShowPasswordChk = true; //비밀번호 확인 보여주기/숨기기
  bool _isEqualPassword = false; //비밀번호-비밀번호 확인 동일한지 체크
  bool _equalPasswordLengthChk = false; //비밀번호 확인 길이 체크
  bool _chkNickname = false;      //별명 확인 메시지용
  bool _chkSameNickname = false;  //이미 등록된 별명인지 체크

  final TextEditingController _mailContorller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChkController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _profileImgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mailContorller.text = '';
    _passwordController.text = '';
    _passwordChkController.text = '';
    _nicknameController.text = '';
    _profileImgController.text = '';
    selected = Info.email;
    _passwordChkController.addListener(() {
      _checkEqualPasswordLength();
      _checkEqualPassword();
    });
    // _focusNode = FocusNode();
  }

  _checkEqualPasswordLength() {
    setState(() {
      if(_passwordChkController.text.length > 5) {
        _equalPasswordLengthChk = true;
      } else {
        _equalPasswordLengthChk = false;
      }
    });
  }

  _checkEqualPassword() {
    if(!_equalPasswordLengthChk) {
      return;
    }
    setState(() {
      if(_passwordController.text.compareTo(_passwordChkController.text) == 0) {
        _isEqualPassword = true;
      } else {
        _isEqualPassword = false;
      }
    });
  }

  _pickProfileImg() async {
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
        print(fileName);
        _profileImgController.text = '$profileImgUrl/$fileName';
        _imgFieldEnabled = false;
      });
    }
    return;
  }

  _imgReset() {
    setState(() {
      _selectedImage = null;
      _imgFieldEnabled = true;
      _profileImgController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = context.watch<MainStore>().deviceWidth;
    var height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.9,
      decoration: BoxDecoration(
          color: Color(0xFF1F1A30).withOpacity(0.9)
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              FadeAnimation(
                  delay: 1,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      '사용자 등록',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  )
              ),
              SizedBox(
                height: height * 0.01,
              ),
              FadeAnimation(
                  delay: 1,
                  child: ListTile(
                    horizontalTitleGap: 5.0,
                    title: TextFormField(
                      onSaved: (val) {

                      },
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          return '이메일 주소는 필수항목입니다.';
                        }
                        if(!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(val)){
                          return '잘못된 이메일 형식입니다.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _chkEmail = false;
                        });
                      },
                      controller: _mailContorller,
                      style: TextStyle(color: Colors.white),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text('이메일 주소'),
                        labelStyle: TextStyle(
                          color: (selected == Info.email) ? enabledTxt : disabled,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        errorText: (_chkSameEmail) ? '사용할 수 없는 이메일입니다.' : null,
                        helperText: '* 필수항목입니다.', //(_chkEmail) ? '사용할 수 있습니다.' : null,
                        helperStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: (selected == Info.email) ? enabled : backgroundColor,
                        prefixIcon: Visibility(
                          visible: _chkEmail,
                          child: Icon(Icons.check_circle, color: Colors.greenAccent,),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selected = Info.email;
                        });
                      },
                    ),
                    trailing: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(buttonColor)
                      ),
                      onPressed: () async{
                        var result = await context.read<MainStore>().checkEmail(_mailContorller.text);
                        setState(() {
                          if(!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(_mailContorller.text)
                              || result == false) {
                            _chkSameEmail = true;
                            _chkEmail = false;
                          } else {
                            _chkSameEmail = false;
                            _chkEmail = true;
                          }
                        });
                      },
                      child: Text('체크', style: TextStyle(color: Colors.white),),
                    ),
                  )
              ),
              SizedBox(
                height: height * 0.01,
              ),
              FadeAnimation(
                  delay: 1,
                  child: ListTile(
                    horizontalTitleGap: 5.0,
                    title: TextFormField(
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          return '비밀번호는 필수항목입니다.';
                        }
                        if(val.length < 8) {
                          return '비밀번호는 8자 이상 입력하여야 합니다.';
                        }
                        if(!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                            .hasMatch(val)){
                          return '비밀번호는 8자 이상, 하나 이상의 숫자, 특수기호를 포함해야 합니다.';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text('비밀번호'),
                        labelStyle: TextStyle(
                          color: (selected == Info.password) ? enabledTxt : disabled,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        helperText:'* 비밀번호는 8자 이상, 숫자, 특수기호를 포함해 주세요.',
                        helperStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: (selected == Info.password) ? enabled : backgroundColor,
                        suffixIcon: IconButton(
                          icon: _isShowPassword
                              ? Icon(Icons.visibility_off, color: (selected == Info.password) ? enabledTxt : disabled, size: 20,)
                              : Icon(Icons.visibility, color: (selected == Info.password) ? enabledTxt : disabled, size: 20,),
                          onPressed: () => setState(() => _isShowPassword = !_isShowPassword),
                        ),
                      ),
                      obscureText: _isShowPassword,
                      onTap: () {
                        setState(() {
                          selected = Info.password;
                        });
                      },
                    ),
                  )
              ),
              SizedBox(
                height: height * 0.01,
              ),
              FadeAnimation(
                  delay: 1,
                  child: ListTile(
                    horizontalTitleGap: 5.0,
                    title: TextFormField(
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          return '비밀번호 확인은 필수항목입니다.';
                        }
                        if(_isEqualPassword == false) {
                          return '비밀번호가 동일하지 않습니다.';
                        }
                        return null;
                      },
                      controller: _passwordChkController,
                      style: TextStyle(color: Colors.white),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text('비밀번호 확인'),
                        labelStyle: TextStyle(
                          color: (selected == Info.passwordChk) ? enabledTxt : disabled,
                        ),
                        helperText: '* 필수 항목입니다.',
                        helperStyle: TextStyle(color: Colors.white70),
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        filled: true,
                        fillColor: (selected == Info.passwordChk) ? enabled : backgroundColor,
                        suffixIcon: IconButton(
                          icon: _isShowPasswordChk
                              ? Icon(Icons.visibility_off, color: (selected == Info.passwordChk) ? enabledTxt : disabled, size: 20,)
                              : Icon(Icons.visibility, color: (selected == Info.passwordChk) ? enabledTxt : disabled, size: 20,),
                          onPressed: () => setState(() => _isShowPasswordChk = !_isShowPasswordChk),
                        ),
                      ),
                      obscureText: _isShowPasswordChk,
                      onTap: () {
                        setState(() {
                          selected = Info.passwordChk;
                        });
                      },
                    ),
                    trailing: Visibility(
                      visible: _isEqualPassword,
                      child: Icon(Icons.check_circle, color: Colors.greenAccent,),
                    ),
                  )
              ),
              SizedBox(
                height: height * 0.01,
              ),
              FadeAnimation(
                  delay: 1,
                  child: ListTile(
                    horizontalTitleGap: 5.0,
                    title: TextFormField(
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          return '별명은 필수항목입니다.';
                        }
                        if(val.length > 8) {
                          return '별명은 8자까지 입력할 수 있습니다.';
                        }
                        return null;
                      },
                      controller: _nicknameController,
                      style: TextStyle(color: Colors.white),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        label: Text('별명'),
                        labelStyle: TextStyle(
                          color: (selected == Info.nickname) ? enabledTxt : disabled,
                        ),
                        errorText: (_chkSameNickname) ? '사용할 수 없거나, 이미 등록된 별명입니다.' : null,
                        helperText: '* 별명은 8자 이하까지 가능합니다.',
                        helperStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: (selected == Info.nickname) ? enabled : backgroundColor,
                        prefixIcon: Visibility(
                          visible: _chkNickname,
                          child: Icon(Icons.check_circle, color: Colors.greenAccent,),
                        ),
                      ),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _chkNickname = false;
                        });
                      },
                      onTap: () {
                        setState(() {
                          selected = Info.nickname;
                        });
                      },
                    ),
                    trailing: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonColor),
                      ),
                      onPressed: () async {
                        var result = await context.read<MainStore>().checkNickname(_nicknameController.text);
                        Future.delayed(Duration(milliseconds: 1000), () {
                          setState(() {
                            if(result == true || _nicknameController.text.length > 8) {
                              _chkSameNickname = true;
                              _chkNickname = false;
                            } else {
                              _chkSameNickname = false;
                              _chkNickname = true;
                            }
                          });
                        });
                      },
                      child: Text('체크', style: TextStyle(color: Colors.white),),
                    ),
                  )
              ),
              SizedBox(
                height: height * 0.01,
              ),
              FadeAnimation(
                  delay: 1,
                  child: ListTile(
                    horizontalTitleGap: 5.0,
                    leading: (_selectedImage == null && _profileImgController.text == '') ?
                    Image.network(
                      '$profileImgUrl/login.png',
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.fitWidth,
                    ) :
                    Image.file(
                      _selectedImage,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network('$profileImgUrl/login.png', width: 50.0, height: 50.0, fit: BoxFit.fitWidth,);
                      },
                    ),
                    title: TextFormField(
                      // enabled: _imgFieldEnabled,
                      controller: _profileImgController,
                      style: TextStyle(color: Colors.white),
                      readOnly: !_imgFieldEnabled,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        helperText: '* 이미지는 10MB 이하만 가능합니다.',
                        helperStyle: TextStyle(color: Colors.white70),
                        hintText: '프로필 이미지',
                        hintStyle: TextStyle(
                          color: (selected == Info.profileImg) ? enabledTxt : disabled,
                        ),
                        filled: true,
                        fillColor: (selected == Info.profileImg) ? enabled : backgroundColor,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _imgReset();
                        });
                      },
                      onTap: () {
                        setState(() {
                          selected = Info.profileImg;
                        });
                      },
                    ),
                    trailing: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonColor),
                      ),
                      onPressed: () {
                        (_selectedImage == null) ? _pickProfileImg() : _imgReset();
                      },
                      child: Text((_selectedImage != null) ? '초기화' : '선택', style: TextStyle(color: Colors.white),),
                    ),
                  )
              ),
              SizedBox(
                height: height * 0.02,
              ),
              FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: warningColor,
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                        child: Text('취소', style: TextStyle(color: Colors.black, letterSpacing: 0.5, fontWeight: FontWeight.bold, fontSize:15),),
                      ),
                      TextButton(
                        onPressed: () async {
                          if(formKey.currentState!.validate()) {
                            if(!_chkEmail) {
                              return showDialog(
                                  context: context,
                                  builder: (context) => CustomAlert(title: '이메일 중복체크를 해주세요.')
                              );
                            }
                            if(!_chkNickname) {
                              return showDialog(
                                  context: context,
                                  builder: (context) => CustomAlert(title: '별명 중복체크를 해주세요.')
                              );
                            }

                            var result = await context.read<MainStore>().signup(
                              _mailContorller.text,
                              _passwordController.text,
                              _nicknameController.text,
                              _profileImgController.text,
                            );
                            if(result) {
                              if(_selectedImage != null) {
                                await context.read<MainStore>().profileImgUpload(_selectedImage);
                                print('로컬에서 선택한 이미지 있음');
                              } else {
                                print('로컬에서 선택한 이미지 없음');
                              }
                              Navigator.pop(context);
                              CustomSnackbar.snackbar(context, '사용자 등록이 완료되었습니다.', 'normal');
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: normalColor,
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                        child: Text('사용자 등록', style: TextStyle(color: Colors.black, letterSpacing: 0.5, fontWeight: FontWeight.bold, fontSize:15),),
                      )
                    ],
                  )
              ),
              SizedBox(
                height: height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
