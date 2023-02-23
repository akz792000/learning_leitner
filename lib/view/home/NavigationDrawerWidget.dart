import 'package:flutter/material.dart';
import '../DownloadView.dart';
import 'package:learning_leitner/view/LeitnerView.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key, required this.onCallback});

  final Function onCallback;

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
          onTap: () {
          },
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
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("Learning"),
              onTap: () {
                // remove Navigation Drawer
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LeitnerView(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text("Download"),
              onTap: () async {
                // remove Navigation Drawer
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DownloadView(),
                  ),
                );
                onCallback();
              },
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text("About"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: const FlutterLogo(),
                  applicationName: "Learning Leitner",
                  applicationVersion: '0.0.2',
                  applicationLegalese: 'Developed by Ali Karimizandi',
                );
              },
            ),
          ],
        ),
      );
}
