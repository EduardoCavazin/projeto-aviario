import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/application/batch_application.dart';
import 'package:projeto_ddm/app/domain/dto/batch_dto.dart';
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

  Future<void> _addOrEditBatch({BatchDTO? batch}) async {
    final TextEditingController _birdCountController = TextEditingController(
      text: batch != null ? batch.birdCount.toString() : '',
    );

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
                controller: _birdCountController,
                decoration: const InputDecoration(labelText: 'Quantidade de Aves'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      final birdCount = int.tryParse(_birdCountController.text);
                      if (birdCount == null || birdCount <= 0 || birdCount > widget.aviaryCapacity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Quantidade inválida de aves')),
                        );
                        return;
                      }

                      try {
                        if (batch == null) {
                          await _batchApplication.createBatch(
                            widget.aviaryId,
                            DateTime.now(),
                            birdCount,
                            'Batch Name', 
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lote adicionado com sucesso!')),
                          );
                        } else {
                          batch.birdCount = birdCount;
                          await _batchApplication.saveBatch(batch);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lote editado com sucesso!')),
                          );
                        }
                        _loadBatches();
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao salvar lote')),
                        );
                      }
                    },
                    child: Text(batch == null ? 'Salvar' : 'Editar'),
                  ),
                  if (batch != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        try {
                          await _batchApplication.deleteBatch(batch.id);
                          _loadBatches();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lote excluído com sucesso!')),
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erro ao excluir lote')),
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

  void _navigateToBatchInfo(BatchDTO batch) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BatchScreenInfo(
          batchId: batch.id,
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
        backgroundColor: const Color.fromARGB(255, 64, 95, 218),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _addOrEditBatch(batch: batch),
                  ),
                  onTap: () => _navigateToBatchInfo(batch),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditBatch(),
        backgroundColor: const Color(0xFF18234E),
        child: const Icon(Icons.add),
      ),
    );
  }
}
