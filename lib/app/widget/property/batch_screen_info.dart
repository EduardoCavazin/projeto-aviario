import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/application/batch_application.dart';
import 'package:projeto_ddm/app/widget/forms/add_feed_form.dart';
import 'package:projeto_ddm/app/widget/forms/add_mortality_form.dart';
import 'package:projeto_ddm/app/widget/forms/add_weight_form.dart';

class BatchScreenInfo extends StatefulWidget {
  final String batchId;
  final String batchName;

  const BatchScreenInfo({
    Key? key,
    required this.batchId,
    required this.batchName,
  }) : super(key: key);

  @override
  _BatchScreenInfoState createState() => _BatchScreenInfoState();
}

class _BatchScreenInfoState extends State<BatchScreenInfo> {
  bool _isLoading = true;
  int birdCount = 0;
  DateTime entryDate = DateTime.now();
  List<Map<String, dynamic>> feedRecords = [];
  List<Map<String, dynamic>> mortalityRecords = [];
  List<Map<String, dynamic>> weightRecords = [];

  @override
  void initState() {
    super.initState();
    _loadBatchData();
  }

  Future<void> _loadBatchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final batch = await BatchApplication().getBatchById(widget.batchId);
      if (batch != null) {
        setState(() {
          birdCount = batch.birdCount;
          entryDate = batch.entryDate;
          feedRecords = batch.feedRecords;
          mortalityRecords = batch.mortalityRecords;
          weightRecords = batch.weightRecords;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do lote: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        form = AddFeedForm(batchId: widget.batchId);
        break;
      case 'mortalidade':
        form = AddMortalityForm(batchId: widget.batchId);
        break;
      case 'peso':
        form = AddWeightForm(batchId: widget.batchId);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => form),
    ).then((_) {
      _loadBatchData(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.batchName),
        backgroundColor: const Color.fromARGB(255, 64, 95, 218),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          Text('Lote: ${widget.batchName}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Quantidade de Aves: $birdCount'),
                          const SizedBox(height: 8),
                          Text(
                            'Data de Entrada: ${entryDate.toLocal().toString().split(' ')[0]}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildRecordCard('Ração', feedRecords, 'quantity'),
                  _buildRecordCard('Mortalidade', mortalityRecords, 'count'),
                  _buildRecordCard('Peso', weightRecords, 'weight'),
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

  Widget _buildRecordCard(
      String title, List<Map<String, dynamic>> records, String valueKey) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (records.isEmpty)
              const Center(
                child: Text('Nenhum registro disponível'),
              )
            else
              ...records.map((record) {
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.info_outline),
                  title: Text('Valor: ${record[valueKey]}'),
                  subtitle: Text('Data: ${record['date']}'),
                  
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
