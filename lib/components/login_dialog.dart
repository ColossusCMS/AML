import 'package:flutter/material.dart';
import 'package:aml/animation/fade_animation.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';

import '../access_info/app_access_info.dart';

enum User {
  email,
  password
}

class LoginDialog extends StatefulWidget {
  LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  Color enabled = Color(0xFF927F9A);
  Color enabledTxt = Colors.white;
  Color disabled = Colors.grey;
  Color backgroundColor = Color(0xFF1F1A30);
  bool _isPassword = true;
  User? selected;
  bool? rememberChecked = false;
  bool _loginError = false;

  // late FocusNode _focusNode;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    emailController.text = '';
    passwordController.text = '';
    selected = User.email;
    // _focusNode = FocusNode();
  }

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Container(
      // height: he * 0.6,
        width: we * 0.75,
        decoration: BoxDecoration(
          color: Color(0xFF1F1A30).withOpacity(0.9),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: we,
            // height: he,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: he * 0.05,
                ),
                FadeAnimation(
                    delay: 0.8,
                    child: Image.network('$assetsUrl/login.png', width: we / 4, )
                ),
                FadeAnimation(
                    delay: 1,
                    child: Text(
                      '사용자 로그인',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    )
                ),
                SizedBox(
                  height: he * 0.04,
                ),
                FadeAnimation(
                  delay: 1,
                  child: Container(
                    width: we * 0.6,
                    // height: he * 0.071,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: (selected == User.email) ? enabled : backgroundColor,
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      // focusNode: _focusNode,
                      autofocus: true,
                      controller: emailController,
                      onTap: () {
                        setState(() {
                          selected = User.email;
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email, color: (selected == User.email) ? enabledTxt : disabled,),
                          hintText: '이메일 주소',
                          hintStyle: TextStyle(
                            color: (selected == User.email) ? enabledTxt : disabled,
                          )
                      ),
                      style: TextStyle(
                        color: (selected == User.email) ? enabledTxt : disabled,
                        fontSize: 22,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: he * 0.02,
                ),
                FadeAnimation(
                    delay: 1,
                    child: Container(
                      width: we * 0.6,
                      // height: he * 0.071,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: (selected == User.password) ? enabled : backgroundColor,
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordController,
                        onTap: () {
                          setState(() {
                            selected = User.password;
                          });
                        },
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock_open_outlined, color: (selected == User.password) ? enabledTxt : disabled,),
                            suffixIcon: IconButton(
                              icon: _isPassword
                                  ? Icon(Icons.visibility_off, color: (selected == User.password) ? enabledTxt : disabled)
                                  : Icon(Icons.visibility, color: (selected == User.password) ? enabledTxt : disabled,),
                              onPressed: () => setState(() =>
                              _isPassword = !_isPassword
                              ),
                            ),
                            hintText: '비밀번호',
                            hintStyle: TextStyle(
                                color: (selected == User.password) ? enabledTxt : disabled
                            )
                        ),
                        obscureText: _isPassword,
                        style: TextStyle(
                          color: (selected == User.password) ? enabledTxt : disabled,
                          fontSize: 22,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                ),
                Visibility(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      '이메일 또는 비밀번호를 확인하세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  visible: _loginError,
                ),
                SizedBox(
                  height: he * 0.01,
                ),
                // FadeAnimation(
                //     delay: 1,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         Row(
                //           children: [
                //             Checkbox(
                //               checkColor: Colors.black,
                //               fillColor: MaterialStateProperty.resolveWith(getColor),
                //               value: rememberChecked,
                //               onChanged: (checked) {
                //                 setState(() {
                //                   rememberChecked = checked;
                //                 });
                //               },
                //             ),
                //             Text('로그인 상태 유지', style: TextStyle(color: Color(0xFF0DF5E4)),)
                //           ],
                //         ),
                //         Text('Forgot Password',
                //           style: TextStyle(
                //               color: Color(0xFF0DF5E4).withOpacity(0.9),
                //               letterSpacing: 0.5
                //           ),
                //         )
                //       ],
                //     )
                // ),
                SizedBox(
                  height: he * 0.01,
                ),
                FadeAnimation(
                    delay: 1,
                    child: TextButton(
                      onPressed: () async {
                        var result = await context.read<MainStore>().signin(emailController.text, passwordController.text);
                        if(result) {
                          setState(() {
                            _loginError = false;
                            CustomSnackbar.snackbar(context, '로그인 성공', 'normal');
                            // if(rememberChecked == true) {
                            //   print('rememberChecked : $rememberChecked');
                            //   context.read<AlbumStore>().savePrefs(true);
                            //   return;
                            // }
                            // context.read<AlbumStore>().savePrefs(false);
                          });
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            _loginError = true;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF0DF5E4),
                          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)
                          )
                      ),
                      child: Text('로그인', style: TextStyle(color: Colors.black, letterSpacing: 0.5, fontWeight: FontWeight.bold, fontSize: 20),),
                    )
                ),
                SizedBox(
                  height: he * 0.07,
                ),
                FadeAnimation(
                    delay: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Container(); }));
                          },
                          child: Text('비밀번호 찾기', style: TextStyle(color: Color(0xFF0DF5E4).withOpacity(0.9), fontWeight: FontWeight.bold, letterSpacing: 0.5),),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Container(); }));
                          },
                          child: Text('사용자 등록', style: TextStyle(color: Color(0xFF0DF5E4).withOpacity(0.9), fontWeight: FontWeight.bold, letterSpacing: 0.5),),
                        )
                      ],
                    )
                ),
                SizedBox(
                  height: he * 0.02,
                )
              ],
            ),
          ),
        )
    );
  }
}
