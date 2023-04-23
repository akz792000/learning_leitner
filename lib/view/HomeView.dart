import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_leitner/enums/CountryEnum.dart';

import '../config/RouteConfig.dart';
import '../model/OptionModel.dart';
import '../service/RouteService.dart';
import 'widget/DrawerWidget.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedOption = 0;
  final _optionModels = [
    OptionModel(
      image: Image.asset('assets/flags/en.png'),
      title: 'English',
      subtitle: 'Learn english sentences.',
      onTap: () async => await Get.find<RouteService>()
          .pushNamed(RouteConfig.level, arguments: LanguageDirectionEnum.en),
    ),
    OptionModel(
      image: Image.asset('assets/flags/de.png'),
      title: 'Deutsch',
      subtitle: 'Englische Sätze lernen.',
      onTap: () async => await Get.find<RouteService>()
          .pushNamed(RouteConfig.level, arguments: LanguageDirectionEnum.de),
    ),
    OptionModel(
      image: Image.asset('assets/database.png'),
      title: 'Data',
      subtitle: 'Write down your sentences.',
      onTap: () async =>
          await Get.find<RouteService>().pushNamed(RouteConfig.data),
    ),
  ];

  @override
  void initState() {
    super.initState();
    debugPrint("HomeView initialize");
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("HomeView dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const DrawerWidget(),
      body: ListView.builder(
        itemCount: _optionModels.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const SizedBox(height: 15.0);
          } else if (index == _optionModels.length + 1) {
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
              leading: _optionModels[index - 1].image,
              title: Text(
                _optionModels[index - 1].title,
                style: TextStyle(
                  color: _selectedOption == index - 1
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
              subtitle: Text(
                _optionModels[index - 1].subtitle,
                style: TextStyle(
                  color:
                      _selectedOption == index - 1 ? Colors.black : Colors.grey,
                ),
              ),
              selected: _selectedOption == index - 1,
              onTap: () {
                setState(() {
                  _selectedOption = index - 1;
                  _optionModels[_selectedOption].onTap!();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
