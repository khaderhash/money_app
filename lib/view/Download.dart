import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Shared_preferences_goal.dart';
import '../services/Shared_preferences_incomes.dart';
import '../services/Shared_preferences_reminders.dart';
import '../services/shared_preferences_expences.dart';

class UploadDataPage extends StatelessWidget {
  const UploadDataPage({super.key});

  Future<void> uploadAllDataToGoogleDrive() async {
    final driveApi = await authenticateAndGetDriveApi();
    if (driveApi != null) {
      try {
        final sharedPreferences = await SharedPreferences.getInstance();
        // خدمات تحميل البيانات
        final expensesService =
            SharedPreferencesServiceexpenses(sharedPreferences);
        final incomesService =
            SharedPreferencesServiceIncomes(sharedPreferences);
        final goalsService = SharedPreferencesServicegoals(sharedPreferences);
        final reminderService =
            SharedPreferencesServiceReminder(sharedPreferences);

        // رفع المصاريف إلى Google Drive
        await expensesService.uploadExpensesToDrive(driveApi);
        // رفع المداخيل إلى Google Drive
        await incomesService.uploadIncomesToDrive(driveApi);

        // رفع الأهداف إلى Google Drive
        final goals =
            await goalsService.getTodo(); // تأكد من الحصول على الأهداف
        await goalsService.uploadGoalsToDrive(driveApi, goals);

        // رفع التذكيرات إلى Google Drive
        final reminders = await reminderService
            .getTReminder(); // تأكد من الحصول على التذكيرات
        await reminderService.uploadRemindersToDrive(driveApi, reminders);

        print('All data has been uploaded to Google Drive!');
      } catch (e) {
        print('Error uploading data: $e');
      }
    } else {
      print('Authentication failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Data to Google Drive'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await uploadAllDataToGoogleDrive();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('All data has been uploaded to Google Drive!')),
            );
          },
          child: const Text('Upload All Data'),
        ),
      ),
    );
  }
}

// دالة المصادقة باستخدام OAuth 2.0
Future<DriveApi?> authenticateAndGetDriveApi() async {
  final clientId = ClientId('<YOUR_CLIENT_ID>', '');
  final scopes = [DriveApi.driveFileScope];
  final prompt = (String url) {
    print('Please go to the following URL and grant access: $url');
  };

  try {
    final client = await clientViaUserConsent(clientId, scopes, prompt);
    return DriveApi(client);
  } catch (e) {
    print('Error during authentication: $e');
    return null;
  }
}
