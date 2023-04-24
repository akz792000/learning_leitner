import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_leitner/enums/CountryEnum.dart';
import 'package:learning_leitner/model/OptionModel.dart';
import 'package:learning_leitner/repository/CardRepository.dart';

import '../config/RouteConfig.dart';
import '../service/RouteService.dart';

class LevelView extends StatefulWidget {
  final LanguageEnum languageEnum;

  const LevelView({
    Key? key,
    required this.languageEnum,
  }) : super(key: key);

  @override
  createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  final CardRepository _cardRepository = Get.find<CardRepository>();
  late int _count;
  int _selectedOption = 0;
  final List<OptionModel> _optionModels = [];

  void initialize() {
    setState(() {
      _count = _cardRepository.findAllByCountry(widget.languageEnum).length;
      _cardRepository
          .findAllLevelBasedByLanguage(widget.languageEnum)
          .forEach((key, value) {
        _optionModels.add(OptionModel(
          level: key,
          image: Image.asset('assets/levels/$key.png'),
          title: "Level $key",
          subtitle: "Items: $value",
        ));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text("${widget.languageEnum.getLanguage()} Level Cards: $_count"),
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            },
          )),
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
                    fontWeight: FontWeight.bold),
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
                });
              },
              trailing: IconButton(
                onPressed: () async =>
                    await Get.find<RouteService>().pushReplacementNamed(
                  RouteConfig.leitner,
                  arguments: {
                    "languageEnum": widget.languageEnum,
                    "level": _optionModels[index - 1].level,
                  },
                ),
                icon: const Icon(
                  Icons.play_circle,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _count == 0
          ? null
          : FloatingActionButton(
              heroTag: 'Play',
              child: const Icon(Icons.play_arrow),
              onPressed: () async =>
                  await Get.find<RouteService>().pushReplacementNamed(
                RouteConfig.leitner,
                arguments: {
                  "languageEnum": widget.languageEnum,
                  "level": -1,
                },
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
              child: SizedBox(
                child: TextButton(
                  child: const Icon(
                    Icons.text_snippet_outlined,
                    color: Colors.lightBlue,
                    size: 26,
                  ),
                  onPressed: () async =>
                      await Get.find<RouteService>().pushReplacementNamed(
                    RouteConfig.data,
                    arguments: {
                      "languageEnum": widget.languageEnum,
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
