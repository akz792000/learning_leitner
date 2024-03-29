import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:learning_leitner/entity/CardEntity.dart';
import 'package:learning_leitner/enums/GroupCode.dart';
import '../config/RouteConfig.dart';
import '../entity/InfoEntity.dart';
import '../repository/CardRepository.dart';
import '../repository/InfoRepository.dart';
import '../service/RouteService.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({Key? key}) : super(key: key);

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  final CardRepository _cardRepository = Get.find<CardRepository>();
  final InfoRepository _infoRepository = Get.find<InfoRepository>();
  final List<Map<String, dynamic>> _items = [
    {"name": "File_0", "toggle": false, "type": "CARD"},
    {"name": "File_1", "toggle": false, "type": "CARD"},
    {"name": "File_2", "toggle": false, "type": "CARD"},
    {"name": "File_3", "toggle": false, "type": "CARD"},
    {"name": "Info_1", "toggle": false, "type": "INFO"},
  ];
  bool _toggle = false;
  int _selectedIndex = 0;

  Future<int> _persistInfo(Map element) async {
    var entity = InfoEntity(
        id: element["id"],
        created: DateTimeUtil.now(),
        modified: DateTimeUtil.now(),
        key: element["key"] ?? "",
        value: element["value"] ?? "",
        groupCode:
            GroupCode.values[element["groupCode"] ?? GroupCode.english.index]);
    return await _infoRepository.merge(entity);
  }

  Future<int> _persistCard(Map element) async {
    var entity = CardEntity(
        id: element["id"],
        created: DateTimeUtil.now(),
        modified: DateTimeUtil.now(),
        level: CardEntity.initLevel,
        subLevel: CardEntity.initSubLevel,
        order: 0,
        fa: element["fa"] ?? "",
        en: element["en"],
        // can be null
        de: element["de"] ?? "",
        desc: element["desc"] ?? "",
        groupCode:
            GroupCode.values[element["groupCode"] ?? GroupCode.english.index]);
    return await _cardRepository.merge(entity);
  }

  Future<void> _download(Map<String, dynamic> item) async {
    var url = Uri.https('raw.githubusercontent.com',
        '/akz792000/Dictionary/main/${item['name']}.json', {'q': '{https}'});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var extractedData =
          List<Map<String, dynamic>>.from(convert.jsonDecode(response.body));
      for (var element in extractedData) {
        if (item['type'] == "CARD") {
          CardEntity? cardEntity = _cardRepository.findById(element["id"]);
          if (cardEntity == null ||
              item["toggle"] ||
              (element["desc"] != null && cardEntity.desc != element["desc"]) ||
              (element["fa"] != null && cardEntity.fa != element["fa"]) ||
              (element["en"] != null && cardEntity.en != element["en"]) ||
              (element["de"] != null && cardEntity.de != element["de"])) {
            _persistCard(element);
          }
        } else {
          InfoEntity? infoEntity = _infoRepository.findById(element["id"]);
          if (infoEntity == null ||
              item["toggle"] ||
              (element["key"] != null && infoEntity.key != element["key"]) ||
              (element["value"] != null && infoEntity.value != element["value"])) {
            _persistInfo(element);
          }
        }
      }
    } else {
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _downloadAll() async {
    var routeService = Get.find<RouteService>();
    try {
      routeService.pushNamed(RouteConfig.loading);
      for (var item in _items) {
        await _download(item);
      }
    } finally {
      debugPrint("Download is ended.");
      Navigator.pop(context);
    }
  }

  void _changeToggleAll() {
    setState(() {
      _toggle = !_toggle;
      for (var item in _items) {
        item["toggle"] = _toggle;
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _downloadAll();
        break;
      case 1:
        _changeToggleAll();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: SwitchListTile(
                title: Text(_items[index]["name"]),
                value: _items[index]["toggle"],
                onChanged: (bool value) {
                  setState(() {
                    _items[index]["toggle"] = value;
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Download',
          ),
          BottomNavigationBarItem(
            icon: _toggle
                ? const Icon(Icons.toggle_on)
                : const Icon(Icons.toggle_off),
            label: 'Override',
          ),
        ],
        onTap: (int index) => _onItemTapped(index),
      ),
    );
  }
}
