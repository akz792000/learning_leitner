import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:learning_leitner/model/CardModel.dart';
import 'package:learning_leitner/view/home/HomeView.dart';
import '../repository/CardModelRepository.dart';
import 'LoadingView.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({Key? key}) : super(key: key);

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  final _cardModelRepository = CardModelRepository();
  final List<Map<String, dynamic>> _items = [
    {"name": "File_0", "toggle": false},
    {"name": "File_1", "toggle": false},
  ];
  bool _toggle = false;
  int _selectedIndex = 0;

  Future<void> _download(Map<String, dynamic> item) async {
    var url = Uri.https('raw.githubusercontent.com',
        '/akz792000/Dictionary/main/${item['name']}.json', {'q': '{https}'});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var extractedData =
          List<Map<String, dynamic>>.from(convert.jsonDecode(response.body));
      for (var element in extractedData) {
        if (item["toggle"]) {
          var cardModel = CardModel(
            id: element["id"],
            fa: element["fa"],
            en: element["en"],
            level: 1,
            created: DateTimeUtil.now(),
            modified: DateTimeUtil.now(),
          );
          _cardModelRepository.persist(cardModel);
        } else {
          CardModel? cardModel = _cardModelRepository.findById(element["id"]);
          if (cardModel == null ||
              cardModel.fa != element["fa"] ||
              cardModel.en != element["en"]) {
            cardModel = CardModel(
              id: element["id"],
              fa: element["fa"],
              en: element["en"],
              level: 1,
              created: DateTimeUtil.now(),
              modified: DateTimeUtil.now(),
            );
            _cardModelRepository.persist(cardModel);
          }
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _downloadAll() async {
    try {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoadingView()));
      for (var item in _items) {
        await _download(item);
      }
    } finally {
      Navigator.of(context).pop();
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
        title: const Text('Download files'),
        centerTitle: true,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeView(),
            ),
          ),
        ),
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
