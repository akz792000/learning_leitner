import 'package:flutter/material.dart';
import 'package:learning_leitner/model/CardModel.dart';
import 'package:learning_leitner/util/ColorUtil.dart';
import 'package:learning_leitner/repository/CardModelRepository.dart';

import '../util/DateTimeUtil.dart';
import '../widget/IconButtonWidget.dart';

class LeitnerView extends StatefulWidget {
  const LeitnerView({Key? key}) : super(key: key);

  @override
  State<LeitnerView> createState() => _LeitnerViewState();
}

class _LeitnerViewState extends State<LeitnerView> {
  final _cardModelRepository = CardModelRepository();
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  late List _cardModels;
  late CardModel _cardModel;

  int _index = 0;
  TextDirection _textDirection = TextDirection.rtl;
  String _language = 'fa';
  int _level = 1;

  @override
  void initState() {
    super.initState();
    debugPrint("Home init call");
    _cardModels = _cardModelRepository.findAllBasedOnLeitner();
    if (_cardModels.isNotEmpty) {
      _cardModel = _cardModels.elementAt(0);
      _level = _cardModel.level;
    } else {
      _index = -1;
    }
  }

  void _changeValue(int index, TextDirection textDirection, String language) {
    setState(() {
      _cardModel = _cardModels.elementAt(index);
      _textDirection = textDirection;
      _language = language;
      _level = _cardModel.level;
    });
  }

  void _changePage() {
    _pageController.animateToPage(_index + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void _onDoubleTap() {
    if (_language == 'fa') {
      _changeValue(_index, TextDirection.ltr, 'en');
    } else {
      _changeValue(_index, TextDirection.rtl, 'fa');
    }
  }

  void _onPageChanged(value) {
    _index = value;
    _changeValue(_index, TextDirection.rtl, 'fa');
  }

  void _onReset() {
    _cardModel.level = CardModel.DEFAULT_LEVEL;
    _cardModel.flag = false;
    _cardModel.modified = DateTimeUtil.now();
    _cardModelRepository.merge(_cardModel);
    setState(() {
      _level = _cardModel.level;
    });
    _changePage();
  }

  void _onThumpUp() {
    if (_cardModel.flag) {
      _cardModel.level--;
      _cardModel.flag = false;
    } else {
      _cardModel.level++;
      _cardModel.flag = true;
    }
    _cardModel.modified = DateTimeUtil.now();
    _cardModelRepository.merge(_cardModel);
    setState(() {
      _level = _cardModel.level;
    });
    _changePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Item ${_index + 1} of ${_cardModels.length}'),
          centerTitle: true,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: GestureDetector(
          onDoubleTap: () => _onDoubleTap(),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => _onPageChanged(value),
            itemBuilder: (context, position) {
              return Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: ColorUtil
                        .gradients[position % ColorUtil.gradients.length],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  _language == 'fa'
                                      ? _cardModel.fa
                                      : _cardModel.en,
                                  textDirection: _textDirection,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButtonWidget(
                            const Icon(Icons.restart_alt,
                                size: 30, color: Colors.red),
                            onPressed: () => _onReset(),
                          ),
                          Text(
                            'Level: $_level',
                            style: const TextStyle(fontSize: 30),
                          ),
                          IconButtonWidget(
                            _cardModel.flag
                                ? const Icon(Icons.thumb_up, size: 30)
                                : const Icon(Icons.thumb_down, size: 30),
                            onPressed: () => _onThumpUp(),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]);
            },
            scrollDirection: Axis.horizontal,
            itemCount: _cardModels.length,
          ),
        ));
  }
}
