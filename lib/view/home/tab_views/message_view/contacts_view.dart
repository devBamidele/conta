import 'dart:developer';

import 'package:conta/res/components/custom/custom_back_button.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/Person.dart';
import '../../../../res/color.dart';
import '../../../../res/components/empty.dart';
import '../../../../utils/widget_functions.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(
          color: AppColors.hintTextColor,
          size: 24,
          padding: EdgeInsets.only(left: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: searchIcon(),
          ),
        ],
        title: const Column(
          children: [
            Text(
              'Select contact',
              style: TextStyle(
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (_, data, __) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: data.findAppUsersFromContact(),
                  builder: (context, AsyncSnapshot<List<Person>> snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      if (data.isEmpty) {
                        return const Empty();
                      }
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Person person = data[index];
                          return ListTile(
                            title: Text(person.username),
                            subtitle: Text(person.bio),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      log('Error fetching chat tiles: ${snapshot.error}');
                      return const Text('Sorry, try again later');
                    } else {
                      return Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: AppColors.primaryShadeColor,
                          size: 48,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
