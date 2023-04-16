import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:learning_leitner/entity/CardEntity.dart';
import '../config/RouteConfig.dart';
import '../repository/CardRepository.dart';
import '../service/RouteService.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({Key? key}) : super(key: key);

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  final _cardRepository = CardRepository();
  final List<Map<String, dynamic>> _items = [
    {"name": "File_0", "toggle": false},
    {"name": "File_1", "toggle": false},
  ];
  bool _toggle = false;
  int _selectedIndex = 0;

  Future<int> persist(Map element) {
    var cardEntity = CardEntity(
      id: element["id"],
      created: DateTimeUtil.now(),
      modified: DateTimeUtil.now(),
      level: CardEntity.newbieLevel,
      subLevel: CardEntity.initSubLevel,
      order: 0,
      fa: element["fa"],
      en: element["en"],
      desc: element["desc"] ?? "",
    );
    return _cardRepository.merge(cardEntity);
  }

  Future<void> _download(Map<String, dynamic> item) async {
    var url = Uri.https('raw.githubusercontent.com',
        '/akz792000/Dictionary/main/${item['name']}.json', {'q': '{https}'});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var extractedData =
          List<Map<String, dynamic>>.from(convert.jsonDecode(response.body));
      for (var element in extractedData) {
        CardEntity? cardEntity = _cardRepository.findById(element["id"]);
        if (cardEntity == null ||
            item["toggle"] ||
            cardEntity.fa != element["fa"] ||
            cardEntity.en != element["en"]) {
          persist(element);
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
