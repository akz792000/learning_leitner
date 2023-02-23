import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_leitner/entity/CardEntity.dart';
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
  final _cardRepository = CardRepository();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _faController;
  late final TextEditingController _enController;
  late final TextEditingController _levelController;
  late final tz.TZDateTime _created;
  late final tz.TZDateTime _modified;
  late final TextEditingController _orderController;

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
    _faController = TextEditingController(text: widget.cardEntity.fa);
    _enController = TextEditingController(text: widget.cardEntity.en);
    _levelController =
        TextEditingController(text: widget.cardEntity.level.toString());
    _created = widget.cardEntity.created;
    _modified = widget.cardEntity.modified;
    _orderController =
        TextEditingController(text: widget.cardEntity.order.toString());
  }

  _onMerge() {
    if (_formKey.currentState!.validate()) {
      var cardEntity = CardEntity(
        id: int.parse(_idController.text),
        fa: _faController.text,
        en: _enController.text,
        level: CardEntity.DEFAULT_LEVEL,
        created: _created,
        modified: DateTimeUtil.now(),
        order: int.parse(_orderController.text),
      );
      _cardRepository.merge(cardEntity);
      Navigator.of(context).pop();
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Card'),
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
              const SizedBox(height: 24.0),
              const Text('Level'),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _levelController,
                validator: _fieldValidator,
              ),
              const SizedBox(height: 24.0),
              const Text('Created'),
              TextFormField(
                initialValue: DateTimeUtil.adjustDateTime(_created),
                readOnly: true,
              ),
              const SizedBox(height: 24.0),
              const Text('Modified'),
              TextFormField(
                initialValue: DateTimeUtil.adjustDateTime(_modified),
                readOnly: true,
              ),
              const SizedBox(height: 24.0),
              const Text('Order'),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _orderController,
                validator: _fieldValidator,
              ),
              const Spacer(),
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
    );
  }
}
