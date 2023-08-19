import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  static final ContactService _instance = ContactService._();

  factory ContactService() => _instance;

  ContactService._();

  List<Contact> userContacts = [];

  Future<void> initContactService() async {
    final permission = await Permission.contacts.status;

    if (permission.isGranted == false &&
        permission.isPermanentlyDenied == false) {
      await Permission.contacts.request();

      fetchContacts();
    }
  }

  Future<void> fetchContacts() async {
    userContacts = await ContactsService.getContacts(withThumbnails: false);
  }
}
