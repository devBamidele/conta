import 'package:permission_handler/permission_handler.dart';

class ContactService {
  static final ContactService _instance = ContactService._();

  factory ContactService() => _instance;

  ContactService._();

  Future<void> initContactService() async {
    // Check for necessary permissions
    final permission = await Permission.contacts.status;

    if (permission.isGranted == false &&
        permission.isPermanentlyDenied == false) {
      await Permission.contacts.request();
    }
  }
}
