import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/repository/CardRepository.dart';

import '../config/RouteConfig.dart';
import '../entity/CardEntity.dart';
import '../service/RouteService.dart';
import '../util/DialogUtil.dart';
import 'DownloadView.dart';

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  final _cardRepository = CardRepository();
  late int _count;

  void _initialize() {
    debugPrint("DataView initialize");
    setState(() {
      _count = _cardRepository.findAll().length;
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

  Future<void> _onDownload() async {
    return await Get.find<RouteService>()
        .pushReplacementNamed(RouteConfig.download)
        .then((value) => Get.find<RouteService>().pushNamed(RouteConfig.data));
  }

  void _onRemoveAll() {
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

  @override
  Widget build(BuildContext context) {
    debugPrint("Home build");
    return Scaffold(
      appBar: AppBar(
        title: Text("Card: $_count"),
      ),
      body: ValueListenableBuilder(
        valueListenable: _cardRepository.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Empty'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var currentBox = box;
                var cardEntity = currentBox.getAt(index)!;
                return Container(
                  color: (index % 2 == 0) ? Colors.white : Colors.blue[100],
                  child: InkWell(
                    onTap: () async => await Get.find<RouteService>()
                        .pushNamed(RouteConfig.merge, arguments: cardEntity),
                    child: ListTile(
                      title: Text(cardEntity.en),
                      subtitle: Text("Level: ${cardEntity.level}"),
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
        onPressed: () async =>
            await Get.find<RouteService>().pushNamed(RouteConfig.persist),
        child: const Icon(Icons.add),
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
                    Icons.cloud_download_rounded,
                    color: Colors.lightBlue,
                    size: 26,
                  ),
                  onPressed: () async => _onDownload(),
                ),
              ),
            ),
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
