import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_ddm/app/application/batch_application.dart';

class AddFeedForm extends StatefulWidget {
  final String batchId;

  const AddFeedForm({Key? key, required this.batchId}) : super(key: key);

  @override
  _AddFeedFormState createState() => _AddFeedFormState();
}

class _AddFeedFormState extends State<AddFeedForm> {
  final BatchApplication _batchApplication = BatchApplication();

  final TextEditingController _quantityController = TextEditingController();
  DateTime? _recordDate;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _recordDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _recordDate = pickedDate;
      });
    }
  }

  Future<void> _saveFeedRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_recordDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data do registro')),
      );
      return;
    }

    final quantity = double.parse(_quantityController.text);

    setState(() {
      _isLoading = true;
    });

    try {
      final feedRecord = {
        'date': _recordDate!.toIso8601String(),
        'quantity': quantity,
      };

      await _batchApplication.addFeedRecord(widget.batchId, feedRecord);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Registro de ração adicionado com sucesso!')),
      );

      Navigator.of(context)
          .pop(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o registro: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Registro de Ração'),
        backgroundColor: const Color.fromARGB(255, 64, 95, 218),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                    labelText: 'Quantidade de Ração (kg)'),
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
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Data do Registro'),
                subtitle: Text(
                  _recordDate == null
                      ? 'Nenhuma data selecionada'
                      : DateFormat('dd/MM/yyyy').format(_recordDate!),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveFeedRecord,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar Registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
