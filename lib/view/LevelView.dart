import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_leitner/enums/CountryEnum.dart';
import 'package:learning_leitner/model/OptionModel.dart';
import 'package:learning_leitner/repository/CardRepository.dart';

import '../config/RouteConfig.dart';
import '../service/RouteService.dart';

class LevelView extends StatefulWidget {
  final LanguageDirectionEnum countryEnum;

  const LevelView({
    Key? key,
    required this.countryEnum,
  }) : super(key: key);

  @override
  createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  final _cardRepository = CardRepository();
  late int _count;
  int _selectedOption = 0;
  final List<OptionModel> _optionModels = [];

  void initialize() {
    setState(() {
      _count = _cardRepository.findAllByCountry(widget.countryEnum).length;
      _cardRepository
          .findAllByCountryAndLevel(widget.countryEnum)
          .forEach((key, value) {
        _optionModels.add(OptionModel(
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
        title: Text("Card: $_count"),
      ),
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
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _count == 0
          ? null
          : FloatingActionButton(
              heroTag: 'Play',
              onPressed: () async => await Get.find<RouteService>()
                  .pushReplacementNamed(RouteConfig.leitner,
                      arguments: widget.countryEnum)
                  .then((value) => Get.find<RouteService>().pushNamed(
                      RouteConfig.level,
                      arguments: widget.countryEnum)),
              child: const Icon(Icons.play_arrow),
            ),
    );
  }
}
