import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/application/property_application.dart';
import 'package:projeto_ddm/app/domain/dto/property_dto.dart';
import 'package:projeto_ddm/app/widget/property/aviary_screen.dart';

class PropertyScreen extends StatefulWidget {
  @override
  _PropertyScreenState createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  final PropertyApplication _propertyApplication = PropertyApplication();
  List<PropertyDTO> _properties = [];
  String? _userId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _aviaryCountController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userId = ModalRoute.of(context)?.settings.arguments as String?;
    if (_userId != null) {
      _loadProperties();
    }
  }

  Future<void> _loadProperties() async {
    if (_userId == null) return;

    try {
      final properties = await _propertyApplication.getAllPropertiesByUser(_userId!);
      setState(() {
        _properties = properties;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar propriedades')),
      );
    }
  }

  Future<void> _addProperty() async {
    if (_userId == null) return;

    if (_nameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _aviaryCountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos são obrigatórios')),
      );
      return;
    }

    final aviaryCount = int.tryParse(_aviaryCountController.text);
    if (aviaryCount == null || aviaryCount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um número válido para o número de aviários')),
      );
      return;
    }

    try {
      await _propertyApplication.createProperty(
        _nameController.text,
        _locationController.text,
        aviaryCount,
        _userId!,
      );

      _nameController.clear();
      _locationController.clear();
      _aviaryCountController.clear();
      _loadProperties();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Propriedade adicionada com sucesso!')),
      );

      Navigator.of(context).pop(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar propriedade')),
      );
    }
  }

  Future<void> _editProperty(PropertyDTO property) async {
    _nameController.text = property.name;
    _locationController.text = property.location;
    _aviaryCountController.text = property.aviaryCount.toString();

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
                decoration: const InputDecoration(labelText: 'Nome da Propriedade'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Localização'),
              ),
              TextField(
                controller: _aviaryCountController,
                decoration: const InputDecoration(labelText: 'Número de Aviários'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      final aviaryCount = int.tryParse(_aviaryCountController.text);
                      if (aviaryCount == null || aviaryCount < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Informe um número válido para o número de aviários')),
                        );
                        return;
                      }

                      try {
                        await _propertyApplication.updateProperty(
                          property.id,
                          _nameController.text,
                          _locationController.text,
                          aviaryCount,
                        );

                        _loadProperties();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Propriedade atualizada com sucesso!')),
                        );
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao atualizar a propriedade')),
                        );
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      try {
                        await _propertyApplication.deleteProperty(property.id);
                        _loadProperties();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Propriedade excluída com sucesso!')),
                        );
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao excluir a propriedade')),
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

  void _showAddPropertyForm() {
    _nameController.clear();
    _locationController.clear();
    _aviaryCountController.clear();

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
                decoration: const InputDecoration(labelText: 'Nome da Propriedade'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Localização'),
              ),
              TextField(
                controller: _aviaryCountController,
                decoration: const InputDecoration(labelText: 'Número de Aviários'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addProperty,
                child: const Text('Salvar Propriedade'),
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
    _locationController.dispose();
    _aviaryCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propriedades'),
        backgroundColor: const Color(0xFF18234E),
      ),
      body: _properties.isEmpty
          ? const Center(child: Text('Nenhuma propriedade cadastrada.'))
          : ListView.builder(
              itemCount: _properties.length,
              itemBuilder: (context, index) {
                final property = _properties[index];
                return ListTile(
                  title: Text(property.name),
                  subtitle: Text(
                    'Localização: ${property.location}, Aviários: ${property.aviaryCount}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AviaryScreen(
                          propertyId: property.id,
                          propertyName: property.name,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => _editProperty(property),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPropertyForm,
        backgroundColor: const Color(0xFF18234E),
        child: const Icon(Icons.add),
      ),
    );
  }
}
