import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis/drive/v3.dart';

final clientId = ClientId(
    '430668013138-71uthpla7h6e4mcsr4f4dc67g3qo5q5q.apps.googleusercontent.com',
    '');
final scopes = [DriveApi.driveFileScope];

Future<void> authenticateAndGetDriveApi() async {
  try {
    // تصحيح اسم الدالة إلى clientViaUserConsent
    final client = await clientViaUserConsent(clientId, scopes, prompt);

    // إنشاء instance من Google Drive API
    final driveApi = DriveApi(client);

    // الحصول على الملفات من Google Drive
    final files = await driveApi.files.list();
    print('Files in Google Drive: ${files.files}');
  } catch (e) {
    print('Error: $e');
  }
}

// دالة تظهر الرابط للمستخدم لكي يقوم بمنحه صلاحيات الوصول
void prompt(String url) {
  print('Please go to the following URL and grant access:');
  print(url);
}
