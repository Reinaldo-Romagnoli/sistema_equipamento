import 'package:flutter/material.dart';
import 'package:sistema_equipamento/Admin/admin_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_helper;
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class EquipmentScreen extends StatefulWidget {
  @override
  _EquipmentScreenState createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  Database? _database;
  List<Map<String, dynamic>> _equipments = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      path_helper.join(dbPath, 'equipment.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE equipments('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'code TEXT, '
          'lastInventoryDate TEXT)',
        );
      },
      version: 1,
    );
    await _mockData();
    await _loadEquipments();
  }

  Future<void> _mockData() async {
    final mockEquipments = [
      {
        'name': 'Notebook',
        'code': '9788542602425',
        'lastInventoryDate':
            DateTime.now().subtract(Duration(days: 15)).toIso8601String(),
      },
      {
        'name': 'Monitor',
        'code': 'EQP002',
        'lastInventoryDate':
            DateTime.now().subtract(Duration(days: 40)).toIso8601String(),
      }
    ];

    for (var equipment in mockEquipments) {
      await _database?.insert(
        'equipments',
        equipment,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _loadEquipments() async {
    final data = await _database?.query('equipments') ?? [];
    setState(() {
      _equipments = data;
    });
  }

  Future<void> _updateInventoryDateByCode(String code) async {
    await _database?.update(
      'equipments',
      {'lastInventoryDate': DateTime.now().toIso8601String()},
      where: 'code = ?',
      whereArgs: [code],
    );
    await _loadEquipments();
  }

  String _formatDateTime(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(parsedDate);
  }

  void _scanQrCode() async {
    final scannedCode = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    );

    if (scannedCode != null && scannedCode is String) {
      await _updateInventoryDateByCode(scannedCode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inventário atualizado para o código: $scannedCode')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF003DA5);
    const greenColor = Color(0xFFA8C539);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Equipamentos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: blueColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: _scanQrCode,
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminScreen(
                    equipments: _equipments,
                    username: 'admin',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _equipments.isEmpty
            ? Center(
                child: Text(
                  'Nenhum equipamento cadastrado',
                  style: TextStyle(color: blueColor, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _equipments.length,
                itemBuilder: (context, index) {
                  final equipment = _equipments[index];
                  final lastInventoryDate =
                      DateTime.parse(equipment['lastInventoryDate']);
                  final isValid =
                      DateTime.now().difference(lastInventoryDate).inDays <= 30;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: greenColor,
                        child: const Icon(
                          Icons.devices,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        equipment['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Código: ${equipment['code']}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            'Último Inventário: ${_formatDateTime(equipment['lastInventoryDate'])}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            isValid
                                ? 'Inventário válido'
                                : 'Necessário realizar inventário',
                            style: TextStyle(
                              color: isValid ? greenColor : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _scanQrCode(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid ? greenColor : Colors.red,
                        ),
                        child: const Text(
                          'Inventariar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}