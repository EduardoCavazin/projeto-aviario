import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_ddm/app/widget/forms/add_feed_form.dart';
import 'package:projeto_ddm/app/widget/forms/add_mortality_form.dart';
import 'package:projeto_ddm/app/widget/forms/add_weight_form.dart';

class BatchScreenInfo extends StatelessWidget {
  final int birdCount;
  final DateTime entryDate;
  final List<Map<String, dynamic>> feedRecords;
  final List<Map<String, dynamic>> mortalityRecords;
  final List<Map<String, dynamic>> weightRecords;
  final String batchName;
  final String batchId;

  const BatchScreenInfo({
    Key? key,
    required this.batchName,
    required this.batchId,
    required this.birdCount,
    required this.entryDate,
    required this.feedRecords,
    required this.mortalityRecords,
    required this.weightRecords,
  }) : super(key: key);

  void _navigateToEditForm(BuildContext context, String type, Map<String, dynamic> record) {
    Widget form;
    switch (type) {
      case 'ração':
        form = AddFeedForm(batchId: batchId, record: record);
        break;
      case 'mortalidade':
        form = AddMortalityForm(batchId: batchId, record: record);
        break;
      case 'peso':
        form = AddWeightForm(batchId: batchId, record: record);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => form),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(batchName),
        backgroundColor: const Color.fromARGB(255, 64, 95, 218),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lote: $batchName',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Quantidade de Aves: $birdCount'),
                    const SizedBox(height: 8),
                    Text('Data de Entrada: ${DateFormat('dd/MM/yyyy').format(entryDate)}'),
                  ],
                ),
              ),
            ),
            _buildDropdown(context, 'Ração', feedRecords, 'quantity', 'ração'),
            _buildDropdown(context, 'Mortalidade', mortalityRecords, 'count', 'mortalidade'),
            _buildDropdown(context, 'Peso', weightRecords, 'weight', 'peso'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddInfoOptions(context),
        backgroundColor: const Color(0xFF18234E),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddInfoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.local_dining),
              title: const Text('Adicionar Ração'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddForm(context, 'ração');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pest_control),
              title: const Text('Adicionar Mortalidade'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddForm(context, 'mortalidade');
              },
            ),
            ListTile(
              leading: const Icon(Icons.scale),
              title: const Text('Adicionar Peso'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddForm(context, 'peso');
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddForm(BuildContext context, String type) {
    Widget form;
    switch (type) {
      case 'ração':
        form = AddFeedForm(batchId: batchId);
        break;
      case 'mortalidade':
        form = AddMortalityForm(batchId: batchId);
        break;
      case 'peso':
        form = AddWeightForm(batchId: batchId);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => form),
    );
  }

  Widget _buildDropdown(BuildContext context, String title, List<Map<String, dynamic>> records, String valueKey, String type) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          if (records.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Nenhum registro disponível'),
            )
          else
            ...records.map((record) {
              return ListTile(
                dense: true,
                leading: const Icon(Icons.info_outline),
                title: Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(record['date']))}',
                ),
                subtitle: Text('Valor: ${record[valueKey]}'),
                onTap: () => _navigateToEditForm(context, type, record),
              );
            }).toList(),
        ],
      ),
    );
  }
}
