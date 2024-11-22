import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/application/batch_application.dart';
import 'package:projeto_ddm/app/domain/dto/batch_dto.dart';
import 'package:projeto_ddm/app/widget/property/add_batch_form.dart';
import 'package:projeto_ddm/app/widget/property/batch_screen_info.dart';

class BatchScreen extends StatefulWidget {
  final String aviaryId;
  final String aviaryName;
  final int aviaryCapacity;

  const BatchScreen({
    Key? key,
    required this.aviaryId,
    required this.aviaryName,
    required this.aviaryCapacity,
  }) : super(key: key);

  @override
  _BatchScreenState createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  final BatchApplication _batchApplication = BatchApplication();
  List<BatchDTO> _batches = [];

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    try {
      final batches = await _batchApplication.getAllBatchesByAviary(widget.aviaryId);
      setState(() {
        _batches = batches;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar lotes')),
      );
    }
  }

  void _navigateToAddBatchForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBatchForm(
          aviaryId: widget.aviaryId,
          aviaryCapacity: widget.aviaryCapacity,
        ),
      ),
    ).then((_) {
      _loadBatches();
    });
  }

  void _navigateToBatchInfo(BatchDTO batch) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BatchScreenInfo(
          batchName: batch.name,
          birdCount: batch.birdCount,
          entryDate: batch.entryDate,
          feedRecords: batch.feedRecords,
          mortalityRecords: batch.mortalityRecords,
          weightRecords: batch.weightRecords,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lotes - ${widget.aviaryName}'),
        backgroundColor: Color.fromARGB(255, 64, 95, 218),
      ),
      body: _batches.isEmpty
          ? const Center(child: Text('Nenhum lote cadastrado.'))
          : ListView.builder(
              itemCount: _batches.length,
              itemBuilder: (context, index) {
                final batch = _batches[index];
                return ListTile(
                  title: Text(
                      'Lote ${batch.entryDate.toLocal().toIso8601String().split('T').first}'),
                  subtitle: Text('${batch.birdCount} aves'),
                  onTap: () => _navigateToBatchInfo(batch),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddBatchForm,
        backgroundColor: const Color(0xFF18234E),
        child: const Icon(Icons.add),
      ),
    );
  }
}
