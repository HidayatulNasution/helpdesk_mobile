import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'dart:io';

class AddTicketScreen extends StatefulWidget {
  @override
  _AddTicketScreenState createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final _bidangSystemController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _problemController = TextEditingController();
  final _resultController = TextEditingController();
  final _statusController = TextEditingController();
  final _prioritasController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();
  final _apiService = ApiService();

  // Function to pick image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to submit the form data to API
  void _submitForm() async {
    try {
      final response = await _apiService.addTicket(
        _bidangSystemController.text,
        _kategoriController.text,
        _problemController.text,
        _resultController.text,
        _statusController.text,
        _prioritasController.text,
        _image, // Gambar bersifat opsional
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket added successfully')),
      );

      // Return to the ticket list after adding the ticket
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ticket: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bidangSystemController,
              decoration: InputDecoration(labelText: 'Bidang System'),
            ),
            TextField(
              controller: _kategoriController,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            TextField(
              controller: _problemController,
              decoration: InputDecoration(labelText: 'Problem'),
            ),
            TextField(
              controller: _resultController,
              decoration: InputDecoration(labelText: 'Result'),
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: _prioritasController,
              decoration: InputDecoration(labelText: 'Prioritas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            if (_image != null)
              Image.file(_image!, height: 200, fit: BoxFit.cover),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
