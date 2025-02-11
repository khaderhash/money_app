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
  String? oldPassword, newPassword, confirmPassword;
  String? oldPasswordError, newPasswordError, confirmPasswordError;
  bool _isPasswordVisible = false,
      _isPasswordVisibleConfirm = false,
      _isOldPasswordVisible = false;
  bool isLoading = false;

  // التحقق من كلمة المرور
  bool isValidPassword(String password) {
    final regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    return regex.hasMatch(password);
  }

  void validateInputs() {
    setState(() {
      oldPasswordError = (oldPassword == null || oldPassword!.isEmpty)
          ? "يجب إدخال كلمة المرور القديمة"
          : null;

      newPasswordError = (newPassword == null || newPassword!.isEmpty)
          ? "يجب إدخال كلمة المرور الجديدة"
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

      // التحقق من كلمة المرور القديمة
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword!,
      );

      try {
        // إعادة المصادقة بكلمة المرور القديمة
        await user.reauthenticateWithCredential(cred);

        // إذا كانت كلمة المرور القديمة صحيحة، يمكن تحديث كلمة المرور الجديدة
        if (newPassword != null && newPassword!.isNotEmpty) {
          await user.updatePassword(newPassword!);
        }

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث البيانات بنجاح')),
        );
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('خطأ'),
              content: Text('كلمة المرور القديمة غير صحيحة.'),
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

              // إدخال كلمة المرور القديمة
              Text('كلمة المرور القديمة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: TextFormField(
                  obscureText: !_isOldPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور القديمة',
                    border: OutlineInputBorder(),
                    errorText: oldPasswordError,
                    suffixIcon: IconButton(
                      icon: Icon(_isOldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isOldPasswordVisible = !_isOldPasswordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldPassword = value;
                      oldPasswordError = null;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),

              // تعديل كلمة المرور الجديدة
              Text('كلمة المرور الجديدة',
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
                          child: Text('تحديث كلمة المرور'),
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
