import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/application/property_application.dart';
import 'package:projeto_ddm/app/domain/dto/property_dto.dart';

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar propriedade')),
      );
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                  child: const Text('Adicionar Propriedade'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _properties.isEmpty
                ? const Center(child: Text('Nenhuma propriedade cadastrada.'))
                : ListView.builder(
                    itemCount: _properties.length,
                    itemBuilder: (context, index) {
                      final property = _properties[index];
                      return ListTile(
                        title: Text(property.name),
                        subtitle: Text('Localização: ${property.location}, Aviários: ${property.aviaryCount}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
