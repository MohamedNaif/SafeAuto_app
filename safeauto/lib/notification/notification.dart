import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notification_service.dart';
import 'widget/notification_button.dart';
import 'widget/top_bar.dart';

class NotificationScrren extends StatefulWidget {
  const NotificationScrren({super.key});

  @override
  State<NotificationScrren> createState() => _NotificationScrrenState();
}

class _NotificationScrrenState extends State<NotificationScrren> {
  @override
  void initState() {
    super.initState();
    setupFirestoreListener();

    //
  }

  void setupFirestoreListener() async {
    FirebaseFirestore.instance
        .collection('Notifications')
        .doc('notifications')
        .snapshots()
        .listen((DocumentSnapshot snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        if (data['motor'] == '1') {
          await NotificationService.showNotification(
              title: "New ",
              body: "Your Engine is Start",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'check',
                  label: 'Check it out',
                  actionType: ActionType.SilentAction,
                  color: Colors.green,
                )
              ]);
        }
        if (data['newImage'] == '1') {
          await NotificationService.showNotification(
              title: "New ",
              body: "Check is Trusted or not",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'check',
                  label: 'Check it out',
                  actionType: ActionType.SilentAction,
                  color: Colors.green,
                )
              ]);
        }
        if (data['door'] == '1') {
          await NotificationService.showNotification(
              title: "New ",
              body: "Door is open",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'check',
                  label: 'Check it out',
                  actionType: ActionType.SilentAction,
                  color: Colors.green,
                )
              ]);
        }
      }
    });
    FirebaseFirestore.instance
        .collection('carStatus')
        .doc('status')
        .snapshots()
        .listen((DocumentSnapshot snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        if (data['isEngineOn'] == true) {
          await NotificationService.showNotification(
              title: "New ",
              body: "Your Engine is Start",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'check',
                  label: 'Check it out',
                  actionType: ActionType.SilentAction,
                  color: Colors.green,
                )
              ]);
        }
        
        if (data['isDoorOpen'] == true) {
          await NotificationService.showNotification(
              title: "New ",
              body: "Door is open",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'check',
                  label: 'Check it out',
                  actionType: ActionType.SilentAction,
                  color: Colors.green,
                )
              ]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Colors.grey[200]!,
          ],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TopBar(title: 'Awesome Notification'),
            // NotificationButton(
            //   text: "Normal Notification",
            //   onPressed: () async {
            //     await NotificationService.showNotification(
            //       title: "Title of the notification",
            //       body: "Body of the notification",
            //     );
            //   },
            // ),
            // NotificationButton(
            //   text: "Notification With Summary",
            //   onPressed: () async {
            //     await NotificationService.showNotification(
            //       title: "Title of the notification",
            //       body: "Body of the notification",
            //       summary: "Small Summary",
            //       notificationLayout: NotificationLayout.Inbox,
            //     );
            //   },
            // ),
            // NotificationButton(
            //   text: "Progress Bar Notification",
            //   onPressed: () async {
            //     await NotificationService.showNotification(
            //       title: "Title of the notification",
            //       body: "Body of the notification",
            //       summary: "Small Summary",
            //       notificationLayout: NotificationLayout.ProgressBar,
            //     );
            //   },
            // ),
            // NotificationButton(
            //   text: "Message Notification",
            //   onPressed: () async {
            //     await NotificationService.showNotification(
            //       title: "Title of the notification",
            //       body: "Body of the notification",
            //       summary: "Small Summary",
            //       notificationLayout: NotificationLayout.Messaging,
            //     );
            //   },
            // ),
            // NotificationButton(
            //   text: "Big Image Notification",
            //   onPressed: () async {
            //     await NotificationService.showNotification(
            //       title: "Title of the notification",
            //       body: "Body of the notification",
            //       summary: "Small Summary",
            //       notificationLayout: NotificationLayout.BigPicture,
            //       bigPicture:
            //           "https://files.tecnoblog.net/wp-content/uploads/2019/09/emoji.jpg",
            //     );
            //   },
            // ),
            NotificationButton(
              text: "Action Buttons Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                    title: "New ",
                    body: "Check is Trusted or not",
                    payload: {
                      "navigate": "true",
                    },
                    actionButtons: [
                      NotificationActionButton(
                        key: 'check',
                        label: 'Check it out',
                        actionType: ActionType.SilentAction,
                        color: Colors.green,
                      )
                    ]);
              },
            ),
            // NotificationButton(
            //   text: "Scheduled Notification",
            //   onPressed: () async {
            //     await NotificationService.showNotification(
            //       title: "Scheduled Notification",
            //       body: "Notification was fired after 5 seconds",
            //       scheduled: true,
            //       interval: 5,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
