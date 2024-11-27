import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Form Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> _fields = [];
  final List<String> _fieldTypes = ['Nom', 'Prénom', 'CIN'];

  void _addField(String type) {
    setState(() {
      _fields.add({'type': type, 'value': ''});
    });
  }

  String _getTextForQRCode() {
    StringBuffer textBuffer = StringBuffer();

    for (var field in _fields) {
      String value = field['value']!;
      textBuffer.write('${field['type']}: $value\n');
    }

    return textBuffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_fields[index]['type']}: ${_fields[index]['value']}'),
                    subtitle: TextField(
                      onChanged: (value) {
                        setState(() {
                          _fields[index]['value'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Entrez votre ${_fields[index]['type']}',
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showFieldTypeDialog();
              },
              child: const Text('Ajouter un champ'),
            ),
            ElevatedButton(
              onPressed: () {
                String qrData = _getTextForQRCode();
                _showQRCodeDialog(qrData);
              },
              child: const Text('Générer Code QR'),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRCodeDialog(String qrData) {
    final qrCode = QrCode(4, QrErrorCorrectLevel.L);  // Niveau de correction d'erreur
    qrCode.addData(qrData);
    qrCode.make();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Code QR Généré'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: QrPainter(qrCode: qrCode),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFieldTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedType;
        return AlertDialog(
          title: const Text('Choisissez le type de champ'),
          content: DropdownButton<String>(
            isExpanded: true,
            value: selectedType,
            items: _fieldTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            hint: const Text('Sélectionnez un type de champ'),
            onChanged: (String? newValue) {
              setState(() {
                selectedType = newValue;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (selectedType != null) {
                  _addField(selectedType!);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}

class QrPainter extends CustomPainter {
  final QrCode qrCode;

  QrPainter({required this.qrCode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final moduleSize = size.width / qrCode.moduleCount;

    for (int x = 0; x < qrCode.moduleCount; x++) {
      for (int y = 0; y < qrCode.moduleCount; y++) {
        if (qrCode.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH(x * moduleSize, y * moduleSize, moduleSize, moduleSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
