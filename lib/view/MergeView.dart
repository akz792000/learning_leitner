import 'package:flutter/material.dart';
import 'package:learning_leitner/model/CardModel.dart';
import 'package:learning_leitner/repository/CardModelRepository.dart';
import 'package:learning_leitner/util/DateTimeUtil.dart';
import 'package:timezone/timezone.dart' as tz;

class MergeView extends StatefulWidget {
  final CardModel cardModel;

  const MergeView({
    super.key,
    required this.cardModel,
  });

  @override
  createState() => _MergeViewState();
}

class _MergeViewState extends State<MergeView> {
  final _cardModelRepository = CardModelRepository();
  final _personFormKey = GlobalKey<FormState>();

  late final TextEditingController _idController;
  late final TextEditingController _faController;
  late final TextEditingController _enController;
  late final TextEditingController _levelController;
  late final tz.TZDateTime _created;
  late final tz.TZDateTime _modified;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Home init call");
    _idController = TextEditingController(text: widget.cardModel.id.toString());
    _faController = TextEditingController(text: widget.cardModel.fa);
    _enController = TextEditingController(text: widget.cardModel.en);
    _levelController =
        TextEditingController(text: widget.cardModel.level.toString());
    _created = widget.cardModel.created;
    _modified = widget.cardModel.modified;
  }

  _onMerge() {
    if (_personFormKey.currentState!.validate()) {
      var cardModel = CardModel(
        id: int.parse(_idController.text),
        fa: _faController.text,
        en: _enController.text,
        level: CardModel.DEFAULT_LEVEL,
        created: _created,
        modified: DateTimeUtil.now(),
      );
      _cardModelRepository.merge(cardModel);
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
          key: _personFormKey,
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
