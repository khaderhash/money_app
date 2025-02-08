import 'package:arabic_font/arabic_font.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../compo/TextFF.dart';
import '../compo/containerclick.dart';
import '../compo/snakhelper.dart';
import '../constants.dart';
import 'login.dart';

class registerpage extends StatefulWidget {
  registerpage({super.key});
  static String id = "registerpage";

  @override
  State<registerpage> createState() => _registerpageState();
}

class _registerpageState extends State<registerpage> {
  bool _isPasswordVisible = false;
  bool _isPasswordVisibleConfirm = false; // للـ Confirm Password
  String? name;
  String? nameError; // لخطأ الاسم

  String? email;
  String? emailError,
      passwordError,
      confirmPasswordError; // إضافة خطأ للـ Confirm Password
  String? password, confirmPassword;
  bool isloading = false;
  GlobalKey<FormState> formkey = GlobalKey();

  // التحقق من كلمة المرور
  bool isValidPassword(String password) {
    final regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    return regex.hasMatch(password);
  }

  // التحقق من البريد الإلكتروني
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  void validateInputs() {
    setState(() {
      nameError =
          (name == null || name!.isEmpty) ? "يجب إدخال اسم المستخدم" : null;

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

      confirmPasswordError =
          (confirmPassword == null || confirmPassword!.isEmpty)
              ? "يجب إدخال تأكيد كلمة المرور"
              : (confirmPassword != password)
                  ? "كلمات المرور غير متطابقة"
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
          child: Padding(
            padding: EdgeInsets.all(hight(context) * .005),
            child: Form(
              key: formkey,
              child: ListView(children: [
                SizedBox(
                  height: hight(context) * .025,
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
                  Image.asset('assets/photo/khader (1).png', height: 150),
                ]),
                SizedBox(
                  height: hight(context) * .01,
                ),
                Container(
                  margin: EdgeInsets.all(width(context) * .05),
                  height: hight(context) * .7,
                  padding: EdgeInsets.all(width(context) * .06),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xFF1e3a4b),
                          width: width(context) * .015),
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: hight(context) * .024,
                      ),
                      TextFormFieldClass(
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
                        height: hight(context) * .024,
                      ),
                      TextFormFieldClass(
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
                        height: hight(context) * .024,
                      ),
                      TextFormFieldClass(
                        obscureTe: !_isPasswordVisibleConfirm,
                        hinttext: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisibleConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimarycolor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisibleConfirm =
                                  !_isPasswordVisibleConfirm;
                            });
                          },
                        ),
                        onchange: (p0) {
                          setState(() {
                            confirmPassword = p0;
                            confirmPasswordError =
                                null; // إزالة الخطأ عند التغيير
                          });
                        },
                        errorText: confirmPasswordError,
                      ),
                      SizedBox(
                        height: hight(context) * .024,
                      ),
                      TextFormFieldClass(
                        hinttext: 'Enter your name',
                        onchange: (p0) {
                          setState(() {
                            name = p0;
                            nameError = null; // إزالة الخطأ عند التغيير
                          });
                        },
                        errorText: nameError,
                      ),
                      SizedBox(
                        height: hight(context) * .03,
                      ),
                      conclickclass(
                        ontap: () async {
                          if (formkey.currentState!.validate()) {
                            validateInputs(); // التحقق من المدخلات

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
                            if (name == null || name!.isEmpty) {
                              setState(() {
                                nameError = "اسم المستخدم مطلوب!";
                              });
                              return;
                            }
                            if (confirmPassword == null ||
                                confirmPassword!.isEmpty) {
                              setState(() {
                                confirmPasswordError =
                                    "تأكيد كلمة المرور مطلوب!";
                              });
                              return;
                            }

                            if (password != confirmPassword) {
                              setState(() {
                                confirmPasswordError =
                                    "كلمات المرور غير متطابقة!";
                              });
                              return;
                            }

                            isloading = true;
                            setState(() {});

                            try {
                              await RUser();
                              Navigator.pushNamed(context, loginpage.id,
                                  arguments: email);
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == 'email-already-in-use') {
                                _showErrorDialogregister(context,
                                    "البريد الإلكتروني مستخدم بالفعل. جرب بريدًا آخر.");
                              } else if (ex.code == 'invalid-email' ||
                                  ex.code == 'ERROR_INVALID_EMAIL') {
                                _showErrorDialogregister(context,
                                    "صيغة البريد الإلكتروني غير صحيحة.");
                              } else if (ex.code == 'weak-password') {
                                _showErrorDialogregister(context,
                                    "كلمة المرور ضعيفة. يجب أن تحتوي على 6 أحرف على الأقل.");
                              } else if (ex.code == 'operation-not-allowed') {
                                _showErrorDialogregister(context,
                                    "تم تعطيل التسجيل بهذا الأسلوب. يرجى التواصل مع الدعم.");
                              } else if (ex.code == 'requires-recent-login') {
                                _showErrorDialogregister(context,
                                    "يجب إعادة تسجيل الدخول لتنفيذ هذا الإجراء.");
                              } else if (ex.code == 'too-many-requests') {
                                _showErrorDialogregister(context,
                                    "تم حظر محاولات التسجيل مؤقتًا بسبب محاولات فاشلة متكررة.");
                              } else if (ex.code == 'network-request-failed') {
                                _showErrorDialogregister(context,
                                    "فشل الاتصال بالشبكة. تحقق من اتصالك بالإنترنت.");
                              } else {
                                _showErrorDialogregister(context,
                                    "حدث خطأ أثناء التسجيل. الرجاء المحاولة لاحقًا.");
                              }
                            } catch (e) {
                              _showErrorDialogregister(
                                  context, "حدث خطأ أثناء الاتصال بالخادم.");
                            }

                            isloading = false;
                            setState(() {});
                          }
                        },
                        Texts: 'Register',
                      ),
                      SizedBox(
                        height: hight(context) * .012,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("you have account? ",
                              style: TextStyle(
                                  fontFamily: kPTajawal, color: kPrimarycolor)),
                          GestureDetector(
                            onTap: () {
                              Get.to(loginpage());
                            },
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: kboldTajwal),
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

  Future<void> RUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );

    // تخزين الاسم في Firebase
    await user.user!.updateDisplayName(name); // تخزين الاسم
  }

  void _showErrorDialogregister(BuildContext context, String message) {
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
//Future<void> updateName(String newName) async {
//   var user = FirebaseAuth.instance.currentUser;
//   await user!.updateDisplayName(newName);
// }
