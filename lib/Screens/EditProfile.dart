import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

      if (newName != null && newName!.isNotEmpty) {
        User? user = FirebaseAuth.instance.currentUser;
        await user!.updateDisplayName(newName);
      }

      if (newPassword != null && newPassword!.isNotEmpty) {
        User? user = FirebaseAuth.instance.currentUser;
        await user!.updatePassword(newPassword!);
      }

      // قم بإضافة منطق آخر إذا كان هناك معلومات إضافية تحتاج إلى التحديث.

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث البيانات بنجاح')),
      );

      // العودة للصفحة السابقة أو تنفيذ أي شيء آخر
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
      appBar: AppBar(
        title: Text('تعديل الملف الشخصي'),
        backgroundColor: Color(0xFFffcc00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // تعديل الاسم
              Text(
                'تعديل الاسم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue:
                    FirebaseAuth.instance.currentUser?.displayName ?? '',
                decoration: InputDecoration(
                  labelText: 'الاسم الجديد',
                  errorText: newNameError,
                ),
                onChanged: (value) {
                  setState(() {
                    newName = value;
                    newNameError = null;
                  });
                },
              ),
              SizedBox(height: 20),

              // تعديل كلمة المرور
              Text(
                'تعديل كلمة المرور',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  errorText: newPasswordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
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
              SizedBox(height: 10),

              // تأكيد كلمة المرور
              TextFormField(
                obscureText: !_isPasswordVisibleConfirm,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  errorText: confirmPasswordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisibleConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisibleConfirm = !_isPasswordVisibleConfirm;
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
              SizedBox(height: 30),

              // زر التحديث
              ElevatedButton(
                onPressed: () {
                  validateInputs();
                  if (_formKey.currentState!.validate()) {
                    updateProfile();
                  }
                },
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text('تحديث البيانات'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
