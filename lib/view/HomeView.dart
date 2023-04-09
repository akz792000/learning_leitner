import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:learning_leitner/view/MergeView.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/view/PersistView.dart';
import 'package:learning_leitner/repository/CardRepository.dart';
import '../entity/CardEntity.dart';
import '../util/DialogUtil.dart';
import 'DrawerWidget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _cardRepository = CardRepository();
  late int _count;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    debugPrint("Home initialize");
    setState(() {
      _count = _cardRepository.findAll().length;
    });
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
      drawer: NavigationDrawerWidget(onCallback: () => _initialize()),
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
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MergeView(
                          cardEntity: cardEntity,
                        ),
                      ),
                    ),
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
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PersistView(),
          ),
        ),
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
