import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:aml/constaints.dart';
import 'package:provider/provider.dart';

import '../access_info/app_access_info.dart';
import '../animation/fade_animation.dart';
import '../components/custom_alert.dart';
import '../stores/main_store.dart';

final auth = FirebaseAuth.instance;

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  var _selectedImage;
  var _profileImgPath;

  _pickImg() async {
    FilePickerResult? imageFile = await FilePicker.platform.pickFiles();
    if (imageFile != null) {
      int fileSize = imageFile.files.single.size;
      String fileName = imageFile.files.single.name;
      if (fileSize > 10500000) {
        return showDialog(
            context: context,
            builder: (context) => CustomAlert(title: '이미지는 10MB이하만 가능합니다.'));
      }
      if (context.read<MainStore>().imgValidateCheck(fileName) == false) {
        print('이미지 파일이 아님');
        return;
      }
      setState(() {
        _selectedImage = File(imageFile.files.single.path.toString());
        _profileImgPath = '$profileImgUrl/$fileName';
      });
    }
    return;
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
        title: Text('사용자 정보'),
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
              SizedBox(
                child: Center(
                  child: (_selectedImage == null)
                      ? Image.network(
                    context.watch<MainStore>().userProfileImg,
                    width: 200,
                    height: 200,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        '$profileImgUrl/login.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.file(
                    _selectedImage,
                    fit: BoxFit.fitWidth,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    _pickImg();
                  },
                  child: (_selectedImage == null)
                      ? Text(
                    '프로필 이미지 변경',
                    style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline),
                  )
                      : ElevatedButton(
                      onPressed: () async {
                        await context.read<MainStore>().updateDocsData(auth.currentUser?.email, 'img', _profileImgPath);
                        await context.read<MainStore>().profileImgUpload(_selectedImage);
                        print('로컬에서 선택한 이미지 있음');
                        setState(() {
                          CustomSnackbar.snackbar(context, '프로필 이미지가 변경되었습니다.', 'normal');
                          _selectedImage = null;
                        });
                      },
                      child: Text('적용하기'))),
              SizedBox(
                child: UserInfoInputBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoInputBox extends StatefulWidget {
  const UserInfoInputBox({Key? key}) : super(key: key);

  @override
  State<UserInfoInputBox> createState() => _UserInfoInputBoxState();
}

class _UserInfoInputBoxState extends State<UserInfoInputBox> {
  TextEditingController email = TextEditingController();
  TextEditingController displayName = TextEditingController();
  TextEditingController profileImage = TextEditingController();
  var duplicateChecked = false;
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    email.text = auth.currentUser?.email ?? '';
    displayName.text = context.read<MainStore>().userNickname ?? '';
    profileImage.text = '';
  }

  _navigateAndCheckPasswordDialog(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckPasswordDialog())
    );

    if(result) {
      showDialog(context: context, builder: (context) => ChangePasswordDialog());
    }
  }

  _navigateAndDeleteUserDialog(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckPasswordDialog())
    );

    if(result) {
      showDialog(context: context, builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        content: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '정말 탈퇴하시겠습니까?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red),
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
                          CustomSnackbar.snackbar(
                              context, '회원탈퇴가 완료되었습니다.', 'normal');
                          context.read<MainStore>().deleteUser();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(
                                Colors.red)),
                        child: Text('탈퇴하기'),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소')),
                  ],
                ),
              )
            ],
          ),
        ),
      )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ListTile(
            leading: Text('아이디'),
            title: TextField(
              controller: email,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  filled: true,
                  fillColor: Colors.white70),
              enabled: false,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: Text('비밀번호'),
            trailing: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFFB2EBF2))),
              onPressed: () {
                _navigateAndCheckPasswordDialog(context);
              },
              child: Text('변경', style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: Text(
              '별명',
            ),
            title: TextFormField(
              validator: (val) {
                if(val == null || val.isEmpty) {
                  return '* 별명은 필수 입력항목입니다.';
                }
                return null;
              },
              controller: displayName,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                errorText: (duplicateChecked) ? '이미 사용하고 있는 별명입니다.' : null,
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            trailing: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFFB2EBF2))),
              onPressed: () async {
                if(formKey.currentState!.validate()) {
                  var result = await context.read<MainStore>().checkNickname(displayName.text);
                  setState(() {
                    duplicateChecked = result;
                  });
                  if (!duplicateChecked) {
                    context.read<MainStore>().updateDocsData(email.text, 'nickname', displayName.text.trim());
                    FocusScope.of(context).unfocus();
                    CustomSnackbar.snackbar(context, '별명 변경이 완료되었습니다.', 'normal');
                  }
                }
              },
              child: Text('변경', style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: Text('회원탈퇴'),
            trailing: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () {
                _navigateAndDeleteUserDialog(context);
              },
              child: Text('회원탈퇴'),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

enum Info {
  password,
  passwordChk,
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final formKey = GlobalKey<FormState>();

  Color enabled = Color(0xFF927F9A);
  Color enabledTxt = Colors.white;
  Color disabled = Colors.grey;
  Color backgroundColor = Color(0xFF1F1A30);
  Info? selected;
  bool _isShowPassword = true;    //비밀번호 보여주기/숨기기
  bool _isShowPasswordChk = true; //비밀번호 확인 보여주기/숨기기
  bool _isEqualPassword = false; //비밀번호-비밀번호 확인 동일한지 체크
  bool _equalPasswordLengthChk = false; //비밀번호 확인 길이 체크

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.text = '';
    _passwordChkController.text = '';
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

  @override
  Widget build(BuildContext context) {
    var width = context.watch<MainStore>().deviceWidth;
    var height = MediaQuery.of(context).size.height;

    return Dialog(
        child: Container(
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
                          '비밀번호 변경',
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
                                var result = await context.read<MainStore>().changePassword(_passwordController.text,);
                                if(result) {
                                  Navigator.pop(context);
                                  CustomSnackbar.snackbar(context, '비밀번호 변경이 완료되었습니다.', 'normal');
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
                            child: Text('비밀번호 변경', style: TextStyle(color: Colors.black, letterSpacing: 0.5, fontWeight: FontWeight.bold, fontSize:15),),
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
        )
    );
  }
}

class CheckPasswordDialog extends StatefulWidget {
  const CheckPasswordDialog({Key? key}) : super(key: key);

  @override
  State<CheckPasswordDialog> createState() => _CheckPasswordDialogState();
}

class _CheckPasswordDialogState extends State<CheckPasswordDialog> {
  final formKey = GlobalKey<FormState>();

  Color enabled = Color(0xFF927F9A);
  Color enabledTxt = Colors.white;
  Color disabled = Colors.grey;
  Color backgroundColor = Color(0xFF1F1A30);
  Info? selected;
  bool _isShowPassword = true;    //비밀번호 보여주기/숨기기
  var checkLogin = true;

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = context.watch<MainStore>().deviceWidth;
    var height = MediaQuery.of(context).size.height;

    return Dialog(
        child: Container(
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
                          '비밀번호 확인',
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
                          validator: (val) {
                            if(val == null || val.isEmpty) {
                              return '비밀번호는 필수항목입니다.';
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
                            errorText: (!checkLogin) ? '비밀번호가 다릅니다.' : '',
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                  FadeAnimation(
                      delay: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, false);
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
                                AuthCredential credential = EmailAuthProvider.credential(
                                  email: auth.currentUser!.email.toString(),
                                  password: _passwordController.text,
                                );
                                auth.currentUser?.reauthenticateWithCredential(credential).then((value) {
                                  checkLogin = true;
                                  Navigator.pop(context, true);
                                }).catchError((error) {
                                  setState(() {
                                    checkLogin = false;
                                  });
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: normalColor,
                                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                )
                            ),
                            child: Text('확인', style: TextStyle(color: Colors.black, letterSpacing: 0.5, fontWeight: FontWeight.bold, fontSize:15),),
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
        )
    );
  }
}
