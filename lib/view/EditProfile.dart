import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../compo/AppBarcom.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  static final id = "Editprofile";

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String? newName, newPassword, confirmPassword;
  String? newNameError, newPasswordError, confirmPasswordError;
  bool _isPasswordVisible = false, _isPasswordVisibleConfirm = false;
  bool isLoading = false;

  // التحقق من كلمة المرور
  bool isValidPassword(String password) {
    final regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    return regex.hasMatch(password);
  }

  // التحقق من الاسم
  bool isValidName(String name) {
    return name.isNotEmpty;
  }

  void validateInputs() {
    setState(() {
      newNameError =
          (newName == null || newName!.isEmpty) ? "يجب إدخال الاسم" : null;
      newPasswordError = (newPassword == null || newPassword!.isEmpty)
          ? "يجب إدخال كلمة المرور"
          : (!isValidPassword(newPassword!))
              ? "كلمة المرور يجب أن تحتوي على 7 أحرف على الأقل مع رقم ورمز خاص"
              : null;
      confirmPasswordError =
          (confirmPassword == null || confirmPassword!.isEmpty)
              ? "يجب إدخال تأكيد كلمة المرور"
              : (confirmPassword != newPassword)
                  ? "كلمات المرور غير متطابقة"
                  : null;
    });
  }

  Future<void> updateProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      User? user = FirebaseAuth.instance.currentUser;
      // تحديث الاسم إذا كان مُدخلًا
      if (newName != null && newName!.isNotEmpty) {
        await user!.updateDisplayName(newName);
      }
      // تحديث كلمة المرور إذا كانت مُدخلة
      if (newPassword != null && newPassword!.isNotEmpty) {
        await user!.updatePassword(newPassword!);
      }
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث البيانات بنجاح')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('خطأ'),
            content: Text(e.message ?? 'حدث خطأ أثناء التحديث.'),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Edit Profile"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .02),

              // تعديل الاسم
              Text('تعديل الاسم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: TextFormField(
                  initialValue:
                      FirebaseAuth.instance.currentUser?.displayName ?? '',
                  decoration: InputDecoration(
                    labelText: 'الاسم الجديد',
                    border: OutlineInputBorder(),
                    errorText: newNameError,
                  ),
                  onChanged: (value) {
                    setState(() {
                      newName = value;
                      newNameError = null;
                    });
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),

              // تعديل كلمة المرور
              Text('تعديل كلمة المرور',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: TextFormField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    border: OutlineInputBorder(),
                    errorText: newPasswordError,
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      newPassword = value;
                      newPasswordError = null;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),

              // تأكيد كلمة المرور
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: TextFormField(
                  obscureText: !_isPasswordVisibleConfirm,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    border: OutlineInputBorder(),
                    errorText: confirmPasswordError,
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisibleConfirm
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisibleConfirm =
                              !_isPasswordVisibleConfirm;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                      confirmPasswordError = null;
                    });
                  },
                ),
              ),
              SizedBox(height: 30),

              // زر التحديث
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: isLoading
                    ? CircularProgressIndicator(key: ValueKey("loading"))
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * .1),
                        child: ElevatedButton(
                          key: ValueKey("button"),
                          onPressed: () {
                            validateInputs();
                            if (_formKey.currentState!.validate()) {
                              updateProfile();
                            }
                          },
                          child: Text('تحديث البيانات'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                            backgroundColor: Color(0xFF507da0),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
