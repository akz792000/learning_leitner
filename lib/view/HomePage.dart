import 'package:flutter/material.dart';

import 'DrawerWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedOption = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    debugPrint("Home initialize");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitner Learning"),
      ),
      drawer: NavigationDrawerWidget(onCallback: () => _initialize()),
      body: ListView.builder(
        itemCount: options.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const SizedBox(height: 15.0);
          } else if (index == options.length + 1) {
            return const SizedBox(height: 100.0);
          }
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: _selectedOption == index - 1
                  ? Border.all(color: Colors.black26)
                  : null,
            ),
            child: ListTile(
              leading: options[index - 1].image,
              title: Text(
                options[index - 1].title,
                style: TextStyle(
                  color: _selectedOption == index - 1
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
              subtitle: Text(
                options[index - 1].subtitle,
                style: TextStyle(
                  color:
                      _selectedOption == index - 1 ? Colors.black : Colors.grey,
                ),
              ),
              selected: _selectedOption == index - 1,
              onTap: () {
                setState(() {
                  _selectedOption = index - 1;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class Option {
  dynamic image;
  String title;
  String subtitle;

  Option(
      {required this.image,
      required this.title,
      required this.subtitle});
}

final options = [
  Option(
    image: Image.asset('assets/flags/en.png'),
    title: 'English',
    subtitle: 'Learn english sentences.',
  ),
  Option(
    image: Image.asset('assets/flags/de.png'),
    title: 'Deutsch',
    subtitle: 'Englische Sätze lernen.',
  ),
  Option(
    image: Image.asset('assets/database.png'),
    title: 'Databases',
    subtitle: 'Write down your sentences.',
  ),
];
