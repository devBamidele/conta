import 'package:flutter/material.dart';

import '../color.dart';

class ReplyBubble extends StatelessWidget {
  const ReplyBubble({
    Key? key,
    required this.replyMessage,
    required this.messageSender,
  }) : super(key: key);

  final String replyMessage;
  final String? messageSender;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(11.5),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.transparentBackground,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 7, 7, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          messageSender ?? 'Before update',
                          style: const TextStyle(
                            color: AppColors.replyMessageColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    replyMessage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.transparentText,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: 4,
              color: AppColors.replyMessageColor,
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}
/*

// Create a Firestore instance
final firestore = FirebaseFirestore.instance;

// Get a reference to the batch
final batch = firestore.batch();

// Add operations to the batch
batch.set(
  firestore.collection('chats').doc(chatId).collection('messages').doc(messageId),
  newMessage.toJson(),
);

// Add more operations to the batch
batch.update(
  firestore.collection('users').doc(userId),
  {'lastMessage': newMessage.content},
);

// Commit the batch
await batch.commit();
In the above example, we first create an instance of WriteBatch using firestore.batch(). Then we add the desired operations to the batch using methods like set, update, and delete. Finally, we commit the batch using batch.commit() to execute all the operations in a single atomic transaction.

This allows you to group multiple operations together and ensures that either all the operations succeed or none of them are applied.


Future<void> addNewMessageToChat(String chatId, String content,
      {required MessageType type, List<String>? media}) async {
    // Generate a unique ID for the new message
    final messageId = const Uuid().v4();

    // Create a new Message object with the specified properties
    final newMessage = Message(
      id: messageId,
      senderId: currentUser!.uid,
      recipientId: currentChat!.uidUser2,
      content: content,
      timestamp: Timestamp.now(),
      replyMessage: cacheReplyMessage?.content,
      replySenderId: cacheReplyMessage?.senderId,
      messageType: type.name,
      media: media,
    );

    // Add the new message and media (if any) to the 'messages' sub-collection of the specified chat document in Firestore
    final messagesCollection = firestore.collection('chats').doc(chatId).collection('messages');
    WriteBatch batch = firestore.batch();
    if (media != null && media.length >= 2 && media.length <= 3) {
      for (int i = 0; i < media.length; i++) {
        final id = const Uuid().v4();
        final imageMessage = Message(
          id: id,
          senderId: currentUser!.uid,
          recipientId: currentChat!.uidUser2,
          content: i == media.length - 1 ? content : '',
          timestamp: Timestamp.now(),
          messageType: MessageType.media.name,
          media: [media[i]],
        );

        batch.set(messagesCollection.doc(id), imageMessage.toJson());
      }
    }
    batch.set(messagesCollection.doc(messageId), newMessage.toJson());
    await batch.commit();
  }




 */
