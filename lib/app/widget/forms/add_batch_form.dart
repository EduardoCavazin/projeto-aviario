import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_ddm/app/application/batch_application.dart';
import 'package:projeto_ddm/app/domain/dto/batch_dto.dart';

class AddBatchForm extends StatefulWidget {
  final String aviaryId;
  final int aviaryCapacity;

  const AddBatchForm({
    Key? key,
    required this.aviaryId,
    required this.aviaryCapacity,
  }) : super(key: key);

  @override
  _AddBatchFormState createState() => _AddBatchFormState();
}

class _AddBatchFormState extends State<AddBatchForm> {
  final BatchApplication _batchApplication = BatchApplication();

  final TextEditingController _birdCountController = TextEditingController();
  final TextEditingController _feedQuantityController = TextEditingController();

  DateTime? _entryDate;
  DateTime? _feedArrivalDate;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, {required bool isEntryDate}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isEntryDate) {
          _entryDate = pickedDate;
        } else {
          _feedArrivalDate = pickedDate;
        }
      });
    }
  }

  Future<void> _saveBatch() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_entryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de início do lote')),
      );
      return;
    }

    if (_feedArrivalDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de chegada da ração')),
      );
      return;
    }

    if (_feedArrivalDate!.isAfter(_entryDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A data de chegada da ração não pode ser posterior à data de início do lote')),
      );
      return;
    }

    final birdCount = int.parse(_birdCountController.text);
    final feedQuantity = double.parse(_feedQuantityController.text);

    if (birdCount > widget.aviaryCapacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('O número de aves não pode exceder ${widget.aviaryCapacity}')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final batchName = 'Lote ${DateFormat('MMMM yyyy', 'pt_BR').format(_entryDate!)}';

      print("Tentando salvar");

      final batch = BatchDTO(
        id: '',
        name: batchName,
        aviaryId: widget.aviaryId,
        entryDate: _entryDate!,
        birdCount: birdCount,
        feedRecords: [
          {'date': _feedArrivalDate!.toIso8601String(), 'quantity': feedQuantity}
        ],
        mortalityRecords: [],
        weightRecords: [],
      );

      await _batchApplication.saveBatch(batch);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lote adicionado com sucesso!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o lote: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _birdCountController.dispose();
    _feedQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Lote'),
        backgroundColor: Color.fromARGB(255, 64, 95, 218),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _birdCountController,
                  decoration: const InputDecoration(labelText: 'Quantidade de Aves'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade de aves';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Digite um número válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _feedQuantityController,
                  decoration: const InputDecoration(labelText: 'Quantidade de Ração (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade de ração';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Digite um número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('Data de Início do Lote'),
                  subtitle: Text(_entryDate == null
                      ? 'Nenhuma data selecionada'
                      : DateFormat('dd/MM/yyyy').format(_entryDate!)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, isEntryDate: true),
                  ),
                ),
                ListTile(
                  title: const Text('Data de Chegada da Primeira Carga de Ração'),
                  subtitle: Text(_feedArrivalDate == null
                      ? 'Nenhuma data selecionada'
                      : DateFormat('dd/MM/yyyy').format(_feedArrivalDate!)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, isEntryDate: false),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveBatch,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Salvar Lote'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
