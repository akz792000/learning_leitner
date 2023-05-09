import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(children: [
            buildHeader(context),
            buildMenuItems(context),
          ]),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.blue.shade400,
        child: InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: Image.asset('assets/image.png').image,
                ),
                const SizedBox(height: 12),
                const Text('Ali Karimizandi',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text("About"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: const FlutterLogo(),
                  applicationName: "Learning Leitner",
                  applicationVersion: '0.0.3',
                  applicationLegalese: 'Developed by Ali Karimizandi',
                );
              },
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                debugPrint("Not implemented yet.");
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
            ),
          ],
        ),
      );
}
