import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/application/aviary_application.dart';
import 'package:projeto_ddm/app/domain/dto/aviary_dto.dart';

class AviaryScreen extends StatefulWidget {
  final String propertyId;
  final String propertyName;

  const AviaryScreen({Key? key, required this.propertyId, required this.propertyName}) : super(key: key);

  @override
  _AviaryScreenState createState() => _AviaryScreenState();
}

class _AviaryScreenState extends State<AviaryScreen> {
  final AviaryApplication _aviaryApplication = AviaryApplication();
  List<AviaryDTO> _aviaries = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAviaries();
  }

  Future<void> _loadAviaries() async {
    try {
      final aviaries = await _aviaryApplication.getAllAviariesByProperty(widget.propertyId);
      setState(() {
        _aviaries = aviaries;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar aviários')),
      );
    }
  }

  Future<void> _addAviary() async {
    if (_nameController.text.isEmpty || _capacityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos são obrigatórios')),
      );
      return;
    }

    final capacity = int.tryParse(_capacityController.text);
    if (capacity == null || capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um número válido para a capacidade')),
      );
      return;
    }

    try {
      await _aviaryApplication.createAviary(
        name: _nameController.text,
        capacity: capacity,
        propertyId: widget.propertyId,
      );

      _nameController.clear();
      _capacityController.clear();
      _loadAviaries();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aviário adicionado com sucesso!')),
      );

      Navigator.of(context).pop(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar aviário')),
      );
    }
  }

  void _showAddAviaryForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Aviário'),
              ),
              TextField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: 'Capacidade do Aviário'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addAviary,
                child: const Text('Salvar Aviário'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aviários - ${widget.propertyName}'),
        backgroundColor: const Color(0xFF18234E),
      ),
      body: _aviaries.isEmpty
          ? const Center(child: Text('Nenhum aviário cadastrado.'))
          : ListView.builder(
              itemCount: _aviaries.length,
              itemBuilder: (context, index) {
                final aviary = _aviaries[index];
                return ListTile(
                  title: Text(aviary.name),
                  subtitle: Text('Capacidade: ${aviary.capacity} aves'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAviaryForm,
        backgroundColor: const Color(0xFF18234E),
        child: const Icon(Icons.add),
      ),
    );
  }
}
