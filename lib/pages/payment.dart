import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


void main() {
  runApp(const MaterialApp(home: ScanAndPayPage()));
}

class ScanAndPayPage extends StatefulWidget {
  const ScanAndPayPage({super.key});

  @override
  State<ScanAndPayPage> createState() => _ScanAndPayPageState();
}

class _ScanAndPayPageState extends State<ScanAndPayPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController upiController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String upiUri = '';

  void generateUpiQR() {
    final name = nameController.text.trim();
    final upi = upiController.text.trim();
    final amount = amountController.text.trim();

    if (name.isEmpty || upi.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }

    setState(() {
      upiUri =
          'upi://pay?pa=$upi&pn=$name&am=$amount&cu=INR'; // UPI payment link
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Web: Scan & Pay")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Payee Name'),
            ),
            TextField(
              controller: upiController,
              decoration: const InputDecoration(labelText: 'Payee UPI ID'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateUpiQR,
              child: const Text("Generate QR"),
            ),
            const SizedBox(height: 20),
            if (upiUri.isNotEmpty) ...[
              const Text(
                "Scan with GPay / PhonePe",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              QrImageView(data: upiUri, version: QrVersions.auto, size: 220.0),
              const SizedBox(height: 10),
              Text(upiUri, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}