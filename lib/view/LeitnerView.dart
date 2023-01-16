import 'package:flutter/material.dart';
import 'package:learning_leitner/entity/CardEntity.dart';
import 'package:learning_leitner/util/ColorUtil.dart';
import 'package:learning_leitner/repository/CardRepository.dart';

import '../util/DateTimeUtil.dart';
import '../widget/IconButtonWidget.dart';
import 'home/HomeView.dart';

class LeitnerView extends StatefulWidget {
  const LeitnerView({Key? key}) : super(key: key);

  @override
  State<LeitnerView> createState() => _LeitnerViewState();
}

class _LeitnerViewState extends State<LeitnerView> {
  final _cardRepository = CardRepository();
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  late List _cards;
  late CardEntity _cardEntity;

  int _index = 0;
  TextDirection _textDirection = TextDirection.rtl;
  String _language = 'fa';
  int _level = 1;

  @override
  void initState() {
    super.initState();
    _cards = _cardRepository.findAllBasedOnLeitner();
    if (_cards.isNotEmpty) {
      _cardEntity = _cards.elementAt(0);
      _cardEntity.flag = null;
      _level = _cardEntity.level;
      _changeOrder();
    } else {
      _index = -1;
    }
  }

  @override
  void dispose() {
    debugPrint("Leitner dispose");
    super.dispose();
    _cardRepository.findAll().forEach((element) {
      element.orderChanged = false;
    });
  }

  void _changeOrder() {
    if (!_cardEntity.orderChanged) {
      _cardEntity.order++;
      _cardEntity.orderChanged = true;
      _cardRepository.merge(_cardEntity);
    }
  }

  void _changeValue(int index, TextDirection textDirection, String language) {
    setState(() {
      _cardEntity = _cards.elementAt(index);
      _textDirection = textDirection;
      _language = language;
      _level = _cardEntity.level;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0 && _language != 'en') {
      // UP
      _changeValue(_index, TextDirection.ltr, 'en');
    } else if (details.primaryVelocity! < 0 && _language != 'fa') {
      // DOWN
      _changeValue(_index, TextDirection.rtl, 'fa');
    }
  }

  void _onPageChanged(value) {
    _index = value;
    _changeValue(_index, TextDirection.rtl, 'fa');
    _changeOrder();
  }

  void _changePage(int level, String flag) {
    _cardEntity.level = level;
    _cardEntity.flag = flag;
    _cardEntity.modified = DateTimeUtil.now();
    _cardRepository.merge(_cardEntity);
    setState(() {
      _level = _cardEntity.level;
    });
    _pageController.animateToPage(_index + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item ${_index + 1} of ${_cards.length}'),
        centerTitle: true,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          _onVerticalDragEnd(details);
        },
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
                                    ? _cardEntity.fa
                                    : _cardEntity.en,
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Level: $_level',
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButtonWidget(
                        _cardEntity.flag == null || _cardEntity.flag == 'UP'
                            ? const Icon(
                                Icons.thumb_down_outlined,
                                size: 30,
                              )
                            : const Icon(
                                Icons.thumb_down,
                                size: 30,
                                color: Colors.red,
                              ),
                        onPressed: () {
                          _changePage(CardEntity.DEFAULT_LEVEL, 'DOWN');
                        },
                      ),
                      IconButtonWidget(
                        _cardEntity.flag == null || _cardEntity.flag == 'DOWN'
                            ? const Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 30,
                              )
                            : const Icon(
                                Icons.thumb_up_alt,
                                size: 30,
                                color: Colors.green,
                              ),
                        onPressed: () {
                          _changePage(_cardEntity.level + 1, 'UP');
                        },
                      ),
                    ],
                  ),
                ),
              )
            ]);
          },
          scrollDirection: Axis.horizontal,
          itemCount: _cards.length,
        ),
      ),
    );
  }
}
