import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_leitner/entity/CardEntity.dart';
import 'package:learning_leitner/service/CardService.dart';
import 'package:learning_leitner/util/ColorUtil.dart';
import 'package:learning_leitner/repository/CardRepository.dart';
import 'package:learning_leitner/view/widget/IconButtonWidget.dart';

import '../config/RouteConfig.dart';
import '../enums/LanguageCode.dart';
import '../enums/GroupCode.dart';
import '../service/RouteService.dart';
import '../util/DateTimeUtil.dart';
import '../util/DialogUtil.dart';

class LeitnerView extends StatefulWidget {
  static const int allLevel = -1;
  static const int allLimitedLevel = -2;

  final GroupCode groupCode;
  final int level;

  const LeitnerView({
    Key? key,
    required this.groupCode,
    required this.level,
  }) : super(key: key);

  @override
  State<LeitnerView> createState() => _LeitnerViewState();
}

class _LeitnerViewState extends State<LeitnerView> {
  final _cardRepository = Get.find<CardRepository>();
  final _cardService = Get.find<CardService>();
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  late List _cards;
  late CardEntity _cardEntity;

  int _index = 0;
  int _level = 1;
  late LanguageCode _languageCode;

  LanguageCode _getInitialLanguageCode() {
    switch (widget.groupCode) {
      case GroupCode.english:
        return LanguageCode.fa;
      case GroupCode.deutsch:
        return LanguageCode.en;
    }
  }

  @override
  void initState() {
    super.initState();
    _languageCode = _getInitialLanguageCode();
    switch (widget.level) {
      case LeitnerView.allLevel:
        _cards = _cardService.findAllBasedOnLeitner(widget.groupCode);
        break;
      case LeitnerView.allLimitedLevel:
        _cards = _cardRepository.findAllByGroupCode(widget.groupCode);
        break;
      default:
        _cards = _cardRepository.findAllByLevelAndGroupCode(
            widget.level, widget.groupCode);
        break;
    }
    if (_cards.isNotEmpty) {
      _cardEntity = _cards.elementAt(0);
      _cardEntity.levelChanged = null;
      _level = _cardEntity.level;
      _modifyOrder();
    } else {
      _index = -1;
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var card in _cards) {
      card.orderChanged = false;
      card.levelChanged = null;
    }
  }

  void _modifyOrder() async {
    if (!_cardEntity.orderChanged) {
      _cardEntity.order++;
      _cardEntity.orderChanged = true;
      await _cardRepository.merge(_cardEntity);
    }
  }

  void _changeValue(int index, LanguageCode languageCode) {
    setState(() {
      _cardEntity = _cards.elementAt(index);
      _languageCode = languageCode;
      _level = _cardEntity.level;
    });
  }

  void _onPageChanged(value) {
    _index = value;
    _changeValue(_index, _getInitialLanguageCode());
    _modifyOrder();
  }

  void _changePage(int level, String levelChanged) async {
    _cardEntity.level = level;
    _cardEntity.subLevel = CardEntity.initSubLevel;
    _cardEntity.levelChanged = levelChanged;
    _cardEntity.modified = DateTimeUtil.now();
    await _cardRepository.merge(_cardEntity);
    setState(() {
      _level = _cardEntity.level;
    });
    if (_index < _cards.length - 1) {
      _pageController.animateToPage(_index + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  /*
   * details.primaryVelocity! > 0 ==> UP
   * details.primaryVelocity! < 0 ==> DOWN
   */
  void _onVerticalDragEnd(DragEndDetails details) {
    switch (widget.groupCode) {
      case GroupCode.english:
        if (_languageCode != LanguageCode.en) {
          _changeValue(_index, LanguageCode.en);
        } else {
          _changeValue(_index, LanguageCode.fa);
        }
        break;
      case GroupCode.deutsch:
        if (_languageCode != LanguageCode.de) {
          _changeValue(_index, LanguageCode.de);
        } else {
          _changeValue(_index, LanguageCode.en);
        }
        break;
    }
  }

  List<Widget> _bottomBar() {
    var result = [
      // dislike
      IconButtonWidget(
          _cardEntity.levelChanged == null || _cardEntity.levelChanged == 'UP'
              ? const Icon(
                  Icons.thumb_down_outlined,
                  size: 30,
                )
              : const Icon(
                  Icons.thumb_down,
                  size: 30,
                  color: Colors.red,
                ),
          onPressed: _cardEntity.levelChanged == 'DOWN'
              ? null
              : () => _changePage(
                    CardEntity.initLevel,
                    'DOWN',
                  ),
          key: const ValueKey("dislike")),

      // desc
      IconButtonWidget(
        const Icon(
          Icons.light_mode_outlined,
          size: 30,
        ),
        onPressed: () {
          DialogUtil.ok(
            context,
            "Description",
            _cardEntity.desc,
            () => {},
          );
        },
        key: const ValueKey("desc"),
      ),

      // like
      IconButtonWidget(
        _cardEntity.levelChanged == null || _cardEntity.levelChanged == 'DOWN'
            ? const Icon(
                Icons.thumb_up_alt_outlined,
                size: 30,
              )
            : const Icon(
                Icons.thumb_up_alt,
                size: 30,
                color: Colors.green,
              ),
        onPressed: _cardEntity.levelChanged == 'UP'
            ? null
            : () => _changePage(
                  _cardEntity.level + 1,
                  'UP',
                ),
        key: const ValueKey("like"),
      ),
    ];

    // remove extra bar button
    result.removeWhere((element) {
      var keyValue = (element.key as ValueKey).value;
      return (keyValue == 'desc' && _cardEntity.desc == "") ||
          (keyValue == 'like' && widget.level != LeitnerView.allLevel);
    });

    return result;
  }

  String _getText() {
    switch (widget.groupCode) {
      case GroupCode.english:
        return _languageCode == LanguageCode.fa ? _cardEntity.fa : _cardEntity.en;
      case GroupCode.deutsch:
        return _languageCode == LanguageCode.en ? _cardEntity.en : _cardEntity.de;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item ${_index + 1} of ${_cards.length}'),
        centerTitle: true,
        leading: InkWell(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () async =>
                await Get.find<RouteService>().pushReplacementNamed(
                  RouteConfig.level,
                  arguments: {
                    "groupCode": widget.groupCode,
                  },
                )),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Level: $_level',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundImage: Image.asset(
                                    'assets/flags/${_languageCode.name}.png')
                                .image,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                _getText(),
                                textDirection: _languageCode.getDirection(),
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
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _bottomBar(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]);
          },
          scrollDirection: Axis.horizontal,
          itemCount: _cards.length,
        ),
      ),
    );
  }
}
