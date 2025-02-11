import 'package:arabic_font/arabic_font.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myappmoney2/view/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import '../compo/TextFF.dart';
import '../compo/containerclick.dart';
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
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2e495e), Color(0xFF507da0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          width: double.infinity,
          // colors: [Color(0xFF2e495e), Color(0xFF507da0)],

          // color: Color(0xFF2e495e),
          child: Padding(
            padding: EdgeInsets.all(hight(context) * .005),
            child: Form(
              key: formkey,
              child: ListView(children: [
                SizedBox(
                  height: hight(context) * .12,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "أبو نجيب",
                        style: ArabicTextStyle(
                            color: Colors.white,
                            arabicFont: ArabicFont.dinNextLTArabic,
                            fontSize: width(context) * .09),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "ABO NAJIB",
                        style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: width(context) * .07,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Image.asset('assets/photo/khader (1).png', height: 160),
                ]),
                SizedBox(
                  height: hight(context) * .01,
                ),
                Container(
                  margin: EdgeInsets.all(width(context) * .05),
                  height: hight(context) * .47,
                  padding: EdgeInsets.all(width(context) * .06),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xFF1e3a4b),
                          width: width(context) * .014),
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                  child: ListView(
                    children: [
                      Text("Gmail",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RobotoSlab',
                              fontSize: 16)),
                      SizedBox(
                        height: hight(context) * .001,
                      ),
                      TextFormFieldClass(
                        hinttext: '',
                        onchange: (p0) {
                          setState(() {
                            email = p0;
                            emailError = null; // إزالة الخطأ عند التغيير
                          });
                        },
                        errorText: emailError,
                      ),
                      SizedBox(
                        height: hight(context) * .015,
                      ),
                      Text("Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RobotoSlab',
                              fontSize: 16)),
                      SizedBox(
                        height: hight(context) * .001,
                      ),
                      TextFormFieldClass(
                        obscureTe: !_isPasswordVisible,
                        hinttext: '',
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
                        height: hight(context) * .04,
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
                              Get.offAll(Homepage(), arguments: email);
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
                              Get.to(registerpage());
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

    // حفظ حالة تسجيل الدخول
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
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
