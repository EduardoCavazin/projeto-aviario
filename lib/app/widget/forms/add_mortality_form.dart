import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_ddm/app/application/batch_application.dart';

class AddMortalityForm extends StatefulWidget {
  final String batchId;

  const AddMortalityForm({Key? key, required this.batchId}) : super(key: key);

  @override
  _AddMortalityFormState createState() => _AddMortalityFormState();
}

class _AddMortalityFormState extends State<AddMortalityForm> {
  final BatchApplication _batchApplication = BatchApplication();

  final TextEditingController _mortalityCountController = TextEditingController();
  DateTime? _mortalityDate;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _mortalityDate = pickedDate;
      });
    }
  }

  Future<void> _saveMortalityRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_mortalityDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data do registro de mortalidade')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final mortalityRecord = {
        'date': _mortalityDate!.toIso8601String(),
        'count': int.parse(_mortalityCountController.text),
      };

      await _batchApplication.addMortalityRecord(widget.batchId, mortalityRecord);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro de mortalidade adicionado com sucesso!')),
      );

      Navigator.of(context).pop(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar registro de mortalidade: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _mortalityCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Mortalidade'),
        backgroundColor: const Color.fromARGB(255, 64, 95, 218),
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
                  controller: _mortalityCountController,
                  decoration: const InputDecoration(labelText: 'Quantidade de Aves Mortas'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade de aves mortas';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Digite um número válido maior que zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('Data do Registro'),
                  subtitle: Text(_mortalityDate == null
                      ? 'Nenhuma data selecionada'
                      : DateFormat('dd/MM/yyyy').format(_mortalityDate!)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveMortalityRecord,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Salvar Registro'),
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
