import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/services/algolia_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Person.dart';
import '../utils/app_utils.dart';

class ContactsProvider extends ChangeNotifier {
  Set<Person> initialContactData = <Person>{};

  List<String?> phoneNumbers = [];

  DateTime? lastCacheTime;

  String? _contactFilter;

  bool triggerFunction = true;

  void updateTrigger(bool trigger) {
    triggerFunction = trigger;
  }

  String? get contactFilter => _contactFilter;

  set contactFilter(String? value) {
    _contactFilter = value;

    notifyListeners();
  }

  clearContactsFilter() {
    _contactFilter = '';

    notifyListeners();
  }

  bool filterContactSearchQuery(
    Person person,
  ) {
    if (contactFilter == null || contactFilter!.isEmpty) {
      return true;
    }
    final username = person.username.toLowerCase();
    return username.contains(contactFilter!.toLowerCase());
  }

  Future<void> getContactsInfo() async {
    initialContactData = await contactsOnDuoTalk(showLabel: false);

    notifyListeners();
  }

  Stream<Set<Person>> fetchContacts() async* {
    if (triggerFunction) {
      final allContacts = await contactsOnDuoTalk(showLabel: true);

      yield allContacts
          .where((person) => filterContactSearchQuery(person))
          .toSet();
    }
  }

  Future<List<String?>> getAndFilterNumbers() async {
    final userContacts =
        await ContactsService.getContacts(withThumbnails: false);

    return userContacts
        .where(
            (contact) => contact.phones != null && contact.phones!.isNotEmpty)
        .map((contact) {
      final phoneNumber = contact.phones!.first.value;

      return phoneNumber.formatPhoneNumber();
    }).toList();
  }

  Future<Set<Person>> findAppUsersFromContact() async {
    final phoneNumbers = await getAndFilterNumbers();

    final userRef = FirebaseFirestore.instance.collection('users');

    // Split phoneNumbers into chunks of 30
    const chunkSize = 30;
    final totalChunks = (phoneNumbers.length / chunkSize).ceil();

    final uniqueContacts = <Person>{};

    // Iterate through the chunks
    for (var i = 0; i < totalChunks; i++) {
      final start = i * chunkSize;
      final end = (i + 1) * chunkSize;

      final chunkNumbers = phoneNumbers.sublist(
        start,
        end < phoneNumbers.length ? end : phoneNumbers.length,
      );

      // Fetch data from Firestore for each chunk
      final querySnapshot =
          await userRef.where('phone', whereIn: chunkNumbers).get();

      // Apply local filtering
      final personList =
          querySnapshot.docs.map((doc) => Person.fromJson(doc.data())).toList();

      // Add the filtered contacts to the uniqueContacts set
      uniqueContacts.addAll(personList);
    }

    return uniqueContacts;
  }

  Future<Set<Person>> contactsOnDuoTalk({
    bool showLabel = false,
  }) async {
    final permission = await Permission.contacts.status;
    final prefs = await SharedPreferences.getInstance();
    final currentDate = DateTime.now();

    if (permission.isGranted) {
      final cachePref = prefs.getString('lastCacheTime');
      lastCacheTime = DateTime.tryParse(cachePref ?? currentDate.toString());
      final fetch =
          currentDate.difference(lastCacheTime!) > const Duration(minutes: 3) ||
              cachePref == null;

      if (fetch) {
        lastCacheTime = currentDate;
        await prefs.setString('lastCacheTime', lastCacheTime.toString());
        initialContactData = await findAppUsersFromContact();
      }

      return initialContactData;
    }

    // Issues with displaying the snackbar
    if (showLabel) {
      // Display Snackbar
      AppUtils.showSnackbar(
        'Allow access to contacts',
        label: 'Open Settings',
        onLabelTapped: openAppSettings,
        delay: const Duration(seconds: 5),
      );
    }

    return {};
  }

  Stream<List<Person>> findAppUsersNotInContacts() async* {
    const algolia = AlgoliaService.algolia;

    final query =
        algolia.instance.index('dev_conta').query(contactFilter ?? '');

    final snapshot = await query.getObjects();

    yield snapshot.hits
        .map((doc) => Person.fromJson(doc.data))
        .where((person) => !phoneNumbers.contains(person.phone))
        .toList();

    // updateEmptySearch(uniquePersons.isEmpty);

    // yield uniquePersons;
  }
}
