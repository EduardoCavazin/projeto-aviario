import 'package:flutter/material.dart';

class BatchScreenInfo extends StatelessWidget {
  final int birdCount;
  final DateTime entryDate;
  final List<Map<String, dynamic>> feedRecords;
  final List<Map<String, dynamic>> mortalityRecords;
  final List<Map<String, dynamic>> weightRecords;
  final String batchName;
  
  

  const BatchScreenInfo({
    Key? key,
    required this.batchName,
    required this.birdCount,
    required this.entryDate,
    required this.feedRecords,
    required this.mortalityRecords,
    required this.weightRecords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$batchName'),
        backgroundColor: Color.fromARGB(255, 64, 95, 218),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Lote: $batchName'),
            Text('Quantidade de Aves: $birdCount'),
            Text('Data de Entrada: ${entryDate.toLocal().toIso8601String()}'),
            const SizedBox(height: 10),
            const Text('Registros de Ração:'),
            for (var record in feedRecords)
              Text('- ${record['date']}: ${record['quantity']} kg'),
            const SizedBox(height: 10),
            const Text('Registros de Mortalidade:'),
            for (var record in mortalityRecords)
              Text('- ${record['date']}: ${record['count']} aves'),
            const SizedBox(height: 10),
            const Text('Registros de Peso:'),
            for (var record in weightRecords)
              Text('- ${record['date']}: ${record['weight']} kg'),
          ],
        ),
      ),
    );
  }
}
