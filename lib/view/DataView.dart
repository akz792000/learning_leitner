import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_leitner/repository/CardRepository.dart';

import '../config/RouteConfig.dart';
import '../entity/CardEntity.dart';
import '../enums/CountryEnum.dart';
import '../helper/ListNotifierHelper.dart';
import '../service/RouteService.dart';
import '../util/DialogUtil.dart';

class DataView extends StatefulWidget {
  final LanguageEnum languageEnum;

  const DataView({
    Key? key,
    required this.languageEnum,
  }) : super(key: key);

  @override
  createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  final _cardRepository = CardRepository();
  late List _cardEntities;

  void _initialize() {
    debugPrint("DataView initialize");
    setState(() {
      _cardEntities =
          _cardRepository.findAllByCountry(widget.languageEnum);
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("DataView dispose");
  }

  void _onRemove(CardEntity cardEntity) {
    DialogUtil.okCancel(
      context,
      "Do you want to delete this item?",
      cardEntity.en,
      () {
        _cardRepository.remove(cardEntity);
        _initialize();
      },
    );
  }

  void _onRemoveAll() {
    if (_cardEntities.isEmpty) {
      DialogUtil.ok(context, "Alert", "There is no item to remove", null);
    } else {
      DialogUtil.okCancel(
        context,
        "Alert",
        "Do you want to delete all items?",
        () {
          _cardRepository.removeAll();
          _initialize();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Home build");
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.languageEnum.getLanguage()} Data Cards: ${_cardEntities.length}"),
        leading: InkWell(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () async =>
                await Get.find<RouteService>().pushReplacementNamed(
                  RouteConfig.level,
                  arguments: {
                    "languageEnum": widget.languageEnum,
                  },
                )),
      ),
      body: ValueListenableBuilder<List>(
        valueListenable: ListNotifierHelper(_cardEntities),
        builder: (context, List cardEntities, widget) {
          if (cardEntities.isEmpty) {
            return const Center(
              child: Text('Empty'),
            );
          } else {
            return ListView.builder(
              itemCount: cardEntities.length,
              itemBuilder: (context, index) {
                var currentBox = cardEntities;
                var cardEntity = currentBox.elementAt(index);
                return Container(
                  color: (index % 2 == 0) ? Colors.white : Colors.blue[100],
                  child: InkWell(
                    onTap: () async => await Get.find<RouteService>()
                        .pushNamed(RouteConfig.merge, arguments: {
                      "cardEntity": cardEntity,
                    }).then((value) => _initialize()),
                    child: ListTile(
                      title: Text(cardEntity.en),
                      subtitle: Text(
                          "Level: ${cardEntity.level} - SubLevel: ${cardEntity.subLevel} - Order: ${cardEntity.order}"),
                      trailing: IconButton(
                        onPressed: () => _onRemove(cardEntity),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'Add',
        onPressed: () async => await Get.find<RouteService>()
            .pushNamed(RouteConfig.persist)
            .then((value) => _initialize()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
              child: SizedBox(
                child: TextButton(
                  child: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _onRemoveAll(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
