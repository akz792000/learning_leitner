import 'package:flutter/material.dart';
import 'package:learning_leitner/entity/CardEntity.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

import '../repository/CardRepository.dart';
import 'home/HomeView.dart';

class PersistView extends StatefulWidget {
  const PersistView({Key? key}) : super(key: key);

  @override
  createState() => _PersistViewState();
}

class _PersistViewState extends State<PersistView> {
  final _cardRepository = CardRepository();
  final _faController = TextEditingController();
  final _enController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  void _onPersist() async {
    if (_formKey.currentState!.validate()) {
      var cardEntity = CardEntity(
        id: 0,
        fa: _faController.text,
        en: _enController.text,
        level: CardEntity.DEFAULT_LEVEL,
        created: DateTimeUtil.now(),
        modified: DateTimeUtil.now(),
        order: 0
      );
      _cardRepository.merge(cardEntity);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Persist Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Farsi'),
              TextFormField(
                textDirection: TextDirection.rtl,
                controller: _faController,
                validator: _fieldValidator,
              ),
              const SizedBox(height: 24.0),
              const Text('English'),
              TextFormField(
                controller: _enController,
                validator: _fieldValidator,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _onPersist(),
                    child: const Text('Persist'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
