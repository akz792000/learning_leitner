import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:learning_leitner/entity/CardEntity.dart';
import 'package:learning_leitner/enums/GroupCode.dart';
import 'package:learning_leitner/repository/CardRepository.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';
import 'package:timezone/timezone.dart' as tz;

class MergeView extends StatefulWidget {
  final CardEntity cardEntity;

  const MergeView({
    super.key,
    required this.cardEntity,
  });

  @override
  createState() => _MergeViewState();
}

class _MergeViewState extends State<MergeView> {
  final CardRepository _cardRepository = Get.find<CardRepository>();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final tz.TZDateTime _created;
  late final tz.TZDateTime _modified;
  late final int _level;
  late final int _subLevel;
  late final TextEditingController _faController;
  late final TextEditingController _enController;
  late final TextEditingController _deController;
  late final TextEditingController _descController;
  late final TextEditingController _orderController;
  late final GroupCode _groupCode;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _idController =
        TextEditingController(text: widget.cardEntity.id.toString());
    _created = widget.cardEntity.created;
    _modified = widget.cardEntity.modified;
    _level = widget.cardEntity.level;
    _subLevel = widget.cardEntity.subLevel;
    _orderController =
        TextEditingController(text: widget.cardEntity.order.toString());
    _faController = TextEditingController(text: widget.cardEntity.fa);
    _enController = TextEditingController(text: widget.cardEntity.en);
    _deController = TextEditingController(text: widget.cardEntity.de);
    _descController = TextEditingController(text: widget.cardEntity.desc);
    _groupCode = widget.cardEntity.groupCode;
  }

  _onMerge() async {
    if (_formKey.currentState!.validate()) {
      var cardEntity = CardEntity(
          id: int.parse(_idController.text),
          created: _created,
          modified: DateTimeUtil.now(),
          level: CardEntity.initLevel,
          subLevel: CardEntity.initSubLevel,
          order: int.parse(_orderController.text),
          fa: _faController.text,
          en: _enController.text,
          de: _deController.text,
          desc: _descController.text,
          groupCode: _groupCode);
      await _cardRepository.merge(cardEntity);
      Navigator.pop(context);
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Merge'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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

                    // level
                    const SizedBox(height: 24.0),
                    const Text(
                      'Level',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      initialValue: _level.toString(),
                      readOnly: true,
                    ),

                    // subLevel
                    const SizedBox(height: 24.0),
                    const Text(
                      'SubLevel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      initialValue: _subLevel.toString(),
                      readOnly: true,
                    ),

                    // created
                    const SizedBox(height: 24.0),
                    const Text(
                      'Created',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      initialValue: DateTimeUtil.adjustDateTime(_created),
                      readOnly: true,
                    ),

                    // modified
                    const SizedBox(height: 24.0),
                    const Text(
                      'Modified',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      initialValue: DateTimeUtil.adjustDateTime(_modified),
                      readOnly: true,
                    ),

                    // order
                    const SizedBox(height: 24.0),
                    const Text(
                      'Order',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: _orderController,
                      validator: _fieldValidator,
                    ),

                    // button
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _onMerge(),
                          child: const Text('Merge'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
