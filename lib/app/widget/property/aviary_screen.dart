import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/application/aviary_application.dart';
import 'package:projeto_ddm/app/domain/dto/aviary_dto.dart';
import 'package:projeto_ddm/app/widget/property/batch_screen_list.dart';

class AviaryScreen extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final int aviaryCount;

  const AviaryScreen({
    Key? key,
    required this.propertyId,
    required this.propertyName,
    required this.aviaryCount,
  }) : super(key: key);

  @override
  _AviaryScreenState createState() => _AviaryScreenState();
}

class _AviaryScreenState extends State<AviaryScreen> {
  final AviaryApplication _aviaryApplication = AviaryApplication();
  List<AviaryDTO> _aviaries = [];
  int _currentAviaryCount = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAviaries();
  }

  Future<void> _loadAviaries() async {
    try {
      final aviaries =
          await _aviaryApplication.getAllAviariesByProperty(widget.propertyId);
      setState(() {
        _aviaries = aviaries;
        _currentAviaryCount = aviaries.length;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar aviários')),
      );
    }
  }

  Future<void> _addOrEditAviary({AviaryDTO? aviary}) async {
    if (aviary != null) {
      _nameController.text = aviary.name;
      _capacityController.text = aviary.capacity.toString();
    } else {
      _nameController.clear();
      _capacityController.clear();
    }

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
                decoration:
                    const InputDecoration(labelText: 'Capacidade do Aviário'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      final capacity = int.tryParse(_capacityController.text);
                      if (capacity == null || capacity <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Capacidade inválida')),
                        );
                        return;
                      }

                      try {
                        if (aviary == null) {
                          await _aviaryApplication.createAviary(
                            name: _nameController.text,
                            capacity: capacity,
                            propertyId: widget.propertyId,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Aviário adicionado com sucesso!')),
                          );
                        } else {
                          aviary.name = _nameController.text;
                          aviary.capacity = capacity;
                          await _aviaryApplication.updateAviary(
                            aviary.id,
                            aviary.name,
                            aviary.capacity,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Aviário editado com sucesso!')),
                          );
                        }
                        _loadAviaries();
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Erro ao salvar aviário')),
                        );
                      }
                    },
                    child: Text(aviary == null ? 'Salvar' : 'Editar'),
                  ),
                  if (aviary != null)
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        try {
                          await _aviaryApplication.deleteAviary(aviary.id);
                          _loadAviaries();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Aviário excluído com sucesso!')),
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Erro ao excluir aviário')),
                          );
                        }
                      },
                      child: const Text('Excluir'),
                    ),
                ],
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
    final isAddButtonDisabled = _currentAviaryCount >= widget.aviaryCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Aviários - ${widget.propertyName}'),
        backgroundColor: const Color.fromARGB(255, 64, 95, 218),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BatchScreen(
                          aviaryId: aviary.id,
                          aviaryName: aviary.name,
                          aviaryCapacity: aviary.capacity,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _addOrEditAviary(aviary: aviary),
                  ),
                );
              },
            ),
      floatingActionButton: isAddButtonDisabled
          ? null
          : FloatingActionButton(
              onPressed: () => _addOrEditAviary(),
              backgroundColor: const Color(0xFF18234E),
              child: const Icon(Icons.add),
            ),
    );
  }
}
