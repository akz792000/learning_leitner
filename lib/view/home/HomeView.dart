import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:learning_leitner/view/MergeView.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/view/PersistView.dart';
import 'package:learning_leitner/repository/CardModelRepository.dart';
import '../../model/CardModel.dart';
import '../../util/DialogUtil.dart';
import 'NavigationDrawerWidget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _cardModelRepository = CardModelRepository();
  late int _count;

  @override
  void initState() {
    super.initState();
    debugPrint("Home init call");
    _setCount();
  }

  void _setCount() {
    setState(() {
      _count = _cardModelRepository.findAll().length;
    });
  }

  void _onRemove(CardModel cardModel) {
    DialogUtil.okCancel(
      context,
      "Do you want to delete this item?",
      cardModel.en,
      () {
        _cardModelRepository.remove(cardModel);
        _setCount();
      },
    );
  }

  void _onRemoveAll() {
    DialogUtil.okCancel(
      context,
      "Alert",
      "Do you want to delete all items?",
      () {
        _cardModelRepository.removeAll();
        setState(() {
          _count = 0;
        });
      },
    );
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card: $_count"),
      ),
      drawer: const NavigationDrawerWidget(),
      body: ValueListenableBuilder(
        valueListenable: _cardModelRepository.listenable(),
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
                var cardModel = currentBox.getAt(index)!;
                return Container(
                  color: (index % 2 == 0) ? Colors.white : Colors.blue[100],
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MergeView(
                          cardModel: cardModel,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(cardModel.en),
                      subtitle: Text("Level: ${cardModel.level}"),
                      trailing: IconButton(
                        onPressed: () => _onRemove(cardModel),
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
