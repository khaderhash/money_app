import 'package:arabic_font/arabic_font.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'register.dart';
import '../compo/TextFF.dart';
import '../compo/containerclick.dart';
import '../compo/snakhelper.dart';
import '../constants.dart';

class loginpage extends StatefulWidget {
  loginpage({super.key});
  static String id = "login";

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  bool isloading = false;
  GlobalKey<FormState> formkey = GlobalKey();
  bool _isPasswordVisible = false;
  String? email, password;
  String? emailError, passwordError; // متغيرات لحفظ الأخطاء
  bool isValidPassword(String password) {
    final regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    return regex.hasMatch(password);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  void validateInputs() {
    setState(() {
      emailError = (email == null || email!.isEmpty)
          ? "يجب إدخال البريد الإلكتروني"
          : (!isValidEmail(email!))
              ? "صيغة البريد الإلكتروني غير صحيحة"
              : null;

      passwordError = (password == null || password!.isEmpty)
          ? "يجب إدخال كلمة المرور"
          : (!isValidPassword(password!))
              ? "كلمة المرور يجب أن تحتوي على 7 أحرف على الأقل مع رقم ورمز خاص"
              : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: Color(0xFFffcc00),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formkey,
              child: ListView(children: [
                SizedBox(
                  height: 75,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "أبو نجيب",
                        style: ArabicTextStyle(
                            arabicFont: ArabicFont.dinNextLTArabic,
                            fontSize: width(context) * .09),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "ABO NAJIB",
                        style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: width(context) * .07,
                            color: kPrimarycolor),
                      ),
                    ],
                  ),
                  Image.asset('assets/photo/khaderlogo.png', height: 150),
                ]),
                SizedBox(
                  height: hight(context) * .01,
                ),
                Container(
                  margin: EdgeInsets.all(22),
                  height: hight(context) * .5,
                  padding: EdgeInsets.all(22),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xFFff9a00),
                          width: width(context) * .013),
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                  child: ListView(
                    children: [
                      Text("Gmail",
                          style: TextStyle(
                              fontFamily: 'RobotoSlab', fontSize: 16)),
                      SizedBox(
                        height: hight(context) * .01,
                      ),
                      textformfieldclass(
                        hinttext: 'Enter Gmail',
                        onchange: (p0) {
                          setState(() {
                            email = p0;
                            emailError = null; // إزالة الخطأ عند التغيير
                          });
                        },
                        errorText: emailError,
                      ),
                      SizedBox(
                        height: hight(context) * .01,
                      ),
                      Text("Password",
                          style: TextStyle(
                              fontFamily: 'RobotoSlab', fontSize: 16)),
                      SizedBox(
                        height: hight(context) * .01,
                      ),
                      textformfieldclass(
                        obscureTe: !_isPasswordVisible,
                        hinttext: 'Enter Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimarycolor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        onchange: (p0) {
                          setState(() {
                            password = p0;
                            passwordError = null; // إزالة الخطأ عند التغيير
                          });
                        },
                        errorText: passwordError,
                      ),
                      SizedBox(
                        height: hight(context) * .03,
                      ),
                      conclickclass(
                        ontap: () async {
                          if (formkey.currentState!.validate()) {
                            if (email == null || email!.isEmpty) {
                              setState(() {
                                emailError = "البريد الإلكتروني مطلوب!";
                              });
                              return;
                            }

                            if (password == null || password!.isEmpty) {
                              setState(() {
                                passwordError = "كلمة المرور مطلوبة!";
                              });
                              return;
                            }
                            if (!isValidEmail(email!)) {
                              setState(() {
                                emailError = "22";
                              });
                              return;
                            }
                            if (!isValidPassword(password!)) {
                              setState(() {
                                passwordError = "22";
                              });
                              return;
                            }

                            isloading = true;
                            setState(() {});

                            try {
                              await loginuser();
                              Navigator.pushNamed(context, Homepage.id,
                                  arguments: email);
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == 'wrong-password' ||
                                  ex.code == 'ERROR_WRONG_PASSWORD') {
                                _showErrorDialog(
                                    context, "كلمة المرور غير صحيحة.");
                              } else if (ex.code == 'user-not-found' ||
                                  ex.code == 'ERROR_USER_NOT_FOUND') {
                                _showErrorDialog(context,
                                    "المستخدم غير موجود. تحقق من البريد الإلكتروني.");
                              } else if (ex.code == 'invalid-email' ||
                                  ex.code == 'ERROR_INVALID_EMAIL') {
                                _showErrorDialog(context,
                                    "صيغة البريد الإلكتروني غير صحيحة.");
                              } else if (ex.code == 'user-disabled' ||
                                  ex.code == 'ERROR_USER_DISABLED') {
                                _showErrorDialog(context,
                                    "تم تعطيل هذا الحساب من قبل المسؤول.");
                              } else if (ex.code == 'too-many-requests') {
                                _showErrorDialog(context,
                                    "تم حظر محاولات تسجيل الدخول مؤقتًا بسبب محاولات فاشلة متكررة.");
                              } else if (ex.code == 'network-request-failed') {
                                _showErrorDialog(context,
                                    "فشل الاتصال بالشبكة. تحقق من اتصالك بالإنترنت.");
                              } else if (ex.code ==
                                  'credential-already-in-use') {
                                _showErrorDialog(context,
                                    "بيانات الاعتماد هذه مستخدمة بالفعل في حساب آخر.");
                              } else if (ex.code == 'requires-recent-login') {
                                _showErrorDialog(context,
                                    "يجب إعادة تسجيل الدخول لتنفيذ هذا الإجراء.");
                              } else if (ex.code == 'operation-not-allowed') {
                                _showErrorDialog(context,
                                    "تم تعطيل تسجيل الدخول بهذا الأسلوب. يرجى التواصل مع الدعم.");
                              } else if (ex.code ==
                                  'account-exists-with-different-credential') {
                                _showErrorDialog(context,
                                    "يوجد حساب بنفس البريد الإلكتروني ولكن بطريقة تسجيل دخول مختلفة.");
                              } else if (ex.code == 'expired-action-code') {
                                _showErrorDialog(context,
                                    "رمز التأكيد منتهي الصلاحية. حاول مرة أخرى.");
                              } else if (ex.code ==
                                  'invalid-verification-code') {
                                _showErrorDialog(context,
                                    "رمز التحقق غير صحيح. حاول مرة أخرى.");
                              } else if (ex.code == 'session-expired') {
                                _showErrorDialog(context,
                                    "انتهت صلاحية الجلسة. يرجى إعادة تسجيل الدخول.");
                              } else {
                                _showErrorDialog(context,
                                    "حدث خطأ أثناء تسجيل الدخول. الرجاء المحاولة لاحقًا.");
                              }
                            } catch (e) {
                              _showErrorDialog(
                                  context, "حدث خطأ أثناء الاتصال بالخادم.");
                            }
                            isloading = false;
                            setState(() {});
                          }
                        },
                        Texts: 'LOGIN',
                      ),
                      SizedBox(
                        height: hight(context) * .025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont have an account? ",
                              style: TextStyle(
                                  fontFamily: kPrimaryFontText,
                                  color: kPrimarycolor)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, registerpage.id);
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: kPrimaryFontText),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginuser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true); // حفظ حالة تسجيل الدخول
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
