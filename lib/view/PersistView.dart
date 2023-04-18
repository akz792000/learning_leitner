import 'package:flutter/material.dart';
import 'package:learning_leitner/entity/CardEntity.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';

import '../repository/CardRepository.dart';

class PersistView extends StatefulWidget {
  const PersistView({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _PersistViewState();
}

class _PersistViewState extends State<PersistView> {
  final _cardRepository = CardRepository();
  final _faController = TextEditingController();
  final _enController = TextEditingController();
  final _deController = TextEditingController();
  final _descController = TextEditingController();
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
        created: DateTimeUtil.now(),
        modified: DateTimeUtil.now(),
        level: CardEntity.newbieLevel,
        subLevel: CardEntity.initSubLevel,
        order: 0,
        fa: _faController.text,
        en: _enController.text,
        de: _deController.text,
        desc: _descController.text,
      );
      _cardRepository.merge(cardEntity);
      Navigator.pop(context);
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Persist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // fa
              const Text(
                'Farsi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                textDirection: TextDirection.rtl,
                controller: _faController,
              ),

              // en
              const SizedBox(height: 24.0),
              const Text(
                'English',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _enController,
                validator: _fieldValidator,
              ),

              // de
              const SizedBox(height: 24.0),
              const Text(
                'Deutsch',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _deController,
              ),

              // desc
              const SizedBox(height: 24.0),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _descController,
              ),

              // button
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
