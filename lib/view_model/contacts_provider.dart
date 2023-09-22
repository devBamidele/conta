import 'dart:developer';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/models/search_results.dart';
import 'package:conta/utils/extensions.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_utils.dart';

class ContactsProvider extends ChangeNotifier {
  Set<SearchResults> initialContactData = <SearchResults>{};

  List<String?> sharedContacts = [];

  DateTime? lastCacheTime;

  String? _contactFilter;

  bool triggerFunction = true;

  final appId = dotenv.env['APP_ID'] as String;
  final apiKey = dotenv.env['API_KEY'] as String;
  final indexName = dotenv.env['INDEX_NAME'] as String;

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

  Future<void> getContactsInfo() async {
    initialContactData = await contactsOnDuoTalk(showLabel: false);

    notifyListeners();
  }

  Stream<Set<SearchResults>> fetchContacts() async* {
    if (triggerFunction) {
      final allContacts = await contactsOnDuoTalk(showLabel: true);

      yield allContacts
          .where((person) => filterContactSearchQuery(person))
          .toSet();
    }
  }

  bool filterContactSearchQuery(
    SearchResults person,
  ) {
    if (contactFilter == null || contactFilter!.isEmpty) {
      return true;
    }
    final username = person.username.toLowerCase();
    return username.contains(contactFilter!.toLowerCase());
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

  Future<Set<SearchResults>> findAppUsersFromContact() async {
    var filteredNumbers = await getAndFilterNumbers();

    final userRef = FirebaseFirestore.instance.collection('users');

    // Split phoneNumbers into chunks of 30
    const chunkSize = 30;
    final totalChunks = (filteredNumbers.length / chunkSize).ceil();

    final uniqueContacts = <SearchResults>{};

    // Iterate through the chunks
    for (var i = 0; i < totalChunks; i++) {
      final start = i * chunkSize;
      final end = (i + 1) * chunkSize;

      final chunkNumbers = filteredNumbers.sublist(
        start,
        end < filteredNumbers.length ? end : filteredNumbers.length,
      );

      // Fetch data from Firestore for each chunk
      final querySnapshot =
          await userRef.where('phone', whereIn: chunkNumbers).get();

      // Apply local filtering
      final personList = querySnapshot.docs
          .map((doc) => SearchResults.fromJson(doc.data()))
          .toList();

      // Add the filtered contacts to the uniqueContacts set
      uniqueContacts.addAll(personList);
    }

    sharedContacts = uniqueContacts.map((info) => info.id).toList();

    return uniqueContacts;
  }

  Future<Set<SearchResults>> contactsOnDuoTalk({
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

  Stream<List<SearchResults>> searchMetadata() {
    final usernameSearcher = HitsSearcher(
      applicationID: appId,
      apiKey: apiKey,
      indexName: indexName,
    );

    usernameSearcher.applyState(
      (state) => state.copyWith(
        page: 0,
        hitsPerPage: 3,
        query: contactFilter,
      ),
    );

    return usernameSearcher.responses.map(
      (response) {
        return response.hits
            .map((data) => SearchResults.fromJson(data))
            .where((result) => filterSharedContacts(result))
            .toList();
      },
    );
  }

  bool filterSharedContacts(SearchResults result) {
    final similar = !sharedContacts.contains(result.id);

    log('The id is ${result.id} and the value of similar is ${!similar}');

    return similar;
  }
}
