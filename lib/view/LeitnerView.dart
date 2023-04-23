import 'package:flutter/material.dart';
import 'package:learning_leitner/entity/CardEntity.dart';
import 'package:learning_leitner/util/ColorUtil.dart';
import 'package:learning_leitner/repository/CardRepository.dart';

import '../enums/CountryEnum.dart';
import '../util/DateTimeUtil.dart';
import '../util/DialogUtil.dart';
import '../widget/IconButtonWidget.dart';

class LeitnerView extends StatefulWidget {
  final LanguageDirectionEnum languageDirectionEnum;

  const LeitnerView({
    Key? key,
    required this.languageDirectionEnum,
  }) : super(key: key);

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
  int _level = 1;
  late LanguageDirectionEnum _languageDirection;

  @override
  void initState() {
    super.initState();
    if (widget.languageDirectionEnum == LanguageDirectionEnum.en) {
      _languageDirection = LanguageDirectionEnum.fa;
    } else {
      _languageDirection = LanguageDirectionEnum.en;
    }
    _cards = _cardRepository.findAllByLeitner(widget.languageDirectionEnum);
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

  void _modifyOrder() {
    if (!_cardEntity.orderChanged) {
      _cardEntity.order++;
      _cardEntity.orderChanged = true;
      _cardRepository.merge(_cardEntity);
    }
  }

  void _changeValue(
      int index, LanguageDirectionEnum language) {
    setState(() {
      _cardEntity = _cards.elementAt(index);
      _languageDirection = language;
      _level = _cardEntity.level;
    });
  }

  void _onPageChanged(value) {
    _index = value;
    _changeValue(_index, widget.languageDirectionEnum == LanguageDirectionEnum.en ? LanguageDirectionEnum.fa : LanguageDirectionEnum.en);
    _modifyOrder();
  }

  void _changePage(int level, String levelChanged) {
    _cardEntity.level = level;
    _cardEntity.subLevel = CardEntity.initSubLevel;
    _cardEntity.levelChanged = levelChanged;
    _cardEntity.modified = DateTimeUtil.now();
    _cardRepository.merge(_cardEntity);
    setState(() {
      _level = _cardEntity.level;
    });
    if (_index < _cards.length - 1) {
      _pageController.animateToPage(_index + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (widget.languageDirectionEnum == LanguageDirectionEnum.en) {
      if (_languageDirection != LanguageDirectionEnum.en) {
        // details.primaryVelocity! > 0 ==> UP
        _changeValue(_index, LanguageDirectionEnum.en);
      } else if (_languageDirection != LanguageDirectionEnum.fa) {
        // details.primaryVelocity! < 0 ==> DOWN
        _changeValue(_index, LanguageDirectionEnum.fa);
      }
    } else {
      if (_languageDirection != LanguageDirectionEnum.de) {
        // details.primaryVelocity! > 0 ==> UP
        _changeValue(_index, LanguageDirectionEnum.de);
      } else if (_languageDirection != LanguageDirectionEnum.en) {
        // details.primaryVelocity! < 0 ==> DOWN
        _changeValue(_index, LanguageDirectionEnum.en);
      }
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
                  CardEntity.newbieLevel,
                  'DOWN',
                ),
      ),

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
      ),
    ];
    if (_cardEntity.desc == "") {
      result.removeAt(1);
    }
    return result;
  }

  String _getText() {
    return widget.languageDirectionEnum == LanguageDirectionEnum.en
        ? (_languageDirection == LanguageDirectionEnum.fa
        ? _cardEntity.fa
        : _cardEntity.en)
        : (_languageDirection == LanguageDirectionEnum.en
        ? _cardEntity.en
        : _cardEntity.de);
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
                                    'assets/flags/${_languageDirection.name}.png')
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
                              child: Text(_getText(),
                                textDirection: _languageDirection.getDirection(),
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
