import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AdminScreen extends StatefulWidget {
  final String username;
  final List<Map<String, dynamic>> equipments;

  const AdminScreen({
    Key? key,
    required this.username,
    required this.equipments,
  }) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> _vinculadosEquipments = [];

  @override
  void initState() {
    super.initState();
    _vinculadosEquipments = List.from(widget.equipments);
  }

  Future<void> _scanQrCode() async {
    final scannedCode = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    );

    if (scannedCode != null && scannedCode is String) {
      setState(() {
        _vinculadosEquipments.add({
          'name': 'Novo Equipamento', // Aqui você pode adicionar lógica para obter o nome.
          'code': scannedCode,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Equipamento adicionado: $scannedCode')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003DA5), // PMS 286 C (azul)
        title: const Text(
          'Administração',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQrCode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, ${widget.username}!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Equipamentos Vinculados:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _vinculadosEquipments.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum equipamento vinculado.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _vinculadosEquipments.length,
                      itemBuilder: (context, index) {
                        final equipment = _vinculadosEquipments[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF99CC00),
                              child: const Icon(
                                Icons.devices,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              equipment['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              'Código: ${equipment['code']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _vinculadosEquipments.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Equipamento removido: ${equipment['code']}'),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Center( // Centraliza o botão
              child: ElevatedButton(
                onPressed: _scanQrCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF99CC00), // PMS 2285 C (verde)
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Adicionar novo equipamento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}