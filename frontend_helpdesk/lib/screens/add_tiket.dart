import 'package:flutter/material.dart';
import '../constants/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../widgets/navbar.dart';
import '../widgets/drawer.dart';

class AddTiket extends StatefulWidget {
  @override
  State<AddTiket> createState() => _AddTiketState();
}

class _AddTiketState extends State<AddTiket> {
  final _bidangSystemController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _problemController = TextEditingController();

  final _apiService = ApiService();

  void _submitForm() async {
    if (_validateForm()) {
      try {
        // Simpan tiket
        await _apiService.addTicket(
          _bidangSystemController.text,
          _kategoriController.text,
          _problemController.text,
          "null", // input result
          "0", // input status
          "0", // input prioritas
        );

        // Kirim notifikasi email
        await _sendEmailNotification();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket added successfully and email sent!'),
            backgroundColor: Colors.blue,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add ticket: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  Future<void> _sendEmailNotification() async {
    final smtpServer =
        gmail(dotenv.env["GMAIL_MAIL"]!, dotenv.env["GMAIL_PASSWORD"]!);
    final message = Message()
      ..from = Address(dotenv.env["GMAIL_MAIL"]!, 'Helpdesk System')
      ..recipients.add('hidayatulnasution2@gmail.com')
      ..ccRecipients.addAll(
          ['safrianaharefa13@gmail.com', 'hidayatulafriahman21@gmail.com'])
      ..subject = 'New Helpdesk Ticket'
      ..text = '''
        Halo Tim Helpdesk,

        Kami ingin memberitahukan bahwa terdapat **tiket komplain baru** yang perlu segera ditindaklanjuti. Mohon segera cek aplikasi Helpdesk untuk melihat detail tiket tersebut.

        Terima kasih atas perhatian dan kerjasamanya.

        Salam hangat,  
        **Helpdesk Support System**
        ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } on MailerException catch (e) {
      print('Failed to send email: $e');
      for (var problem in e.problems) {
        print('Problem: ${problem.code}: ${problem.msg}');
      }
    }
  }

  bool _validateForm() {
    return _bidangSystemController.text.isNotEmpty &&
        _kategoriController.text.isNotEmpty &&
        _problemController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Add Tiket",
        searchBar: false,
        categoryOne: "List Tiket",
        categoryTwo: "Add Tiket",
      ),
      backgroundColor: const Color.fromARGB(255, 224, 224, 224),
      drawer: ArgonDrawer(currentPage: "Add Tiket"),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInputField(
                    controller: _bidangSystemController,
                    label: 'Bidang System',
                    icon: Icons.computer,
                  ),
                  SizedBox(height: 20),
                  _buildDropdownField(
                    label: 'Kategori',
                    items: ['Bug', 'Feature Request', 'Other'],
                    value: _kategoriController.text.isEmpty
                        ? null
                        : _kategoriController.text,
                    onChanged: (value) {
                      setState(() {
                        _kategoriController.text = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _buildInputField(
                    controller: _problemController,
                    label: 'Problem',
                    icon: Icons.report_problem,
                    multiline: true,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: Icon(Icons.send),
                    label: Text('Submit Ticket'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool multiline = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: multiline ? 5 : 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    String? value,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
