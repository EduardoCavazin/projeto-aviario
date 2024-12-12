import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_ddm/app/application/batch_application.dart';

class AddWeightForm extends StatefulWidget {
  final String batchId;
  final Map<String, dynamic>? record;

  const AddWeightForm({Key? key, required this.batchId, this.record}) : super(key: key);

  @override
  _AddWeightFormState createState() => _AddWeightFormState();
}

class _AddWeightFormState extends State<AddWeightForm> {
  final BatchApplication _batchApplication = BatchApplication();

  final TextEditingController _weightController = TextEditingController();
  DateTime? _weightDate;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _weightController.text = widget.record!['weight'].toString();
      _weightDate = DateTime.parse(widget.record!['date']);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _weightDate = pickedDate;
      });
    }
  }

  Future<void> _saveWeightRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_weightDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data do registro de peso')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final weightRecord = {
        'date': _weightDate!.toIso8601String(),
        'weight': double.parse(_weightController.text),
      };

      await _batchApplication.addWeightRecord(widget.batchId, weightRecord);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro de peso adicionado com sucesso!')),

      );

      Navigator.of(context).pop(); // Fecha o formulário após salvar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar registro de peso: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Registro de Peso'),
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
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Peso Médio (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o peso médio';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Digite um número válido maior que zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('Data do Registro'),
                  subtitle: Text(_weightDate == null
                      ? 'Nenhuma data selecionada'
                      : DateFormat('dd/MM/yyyy').format(_weightDate!)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveWeightRecord,
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
