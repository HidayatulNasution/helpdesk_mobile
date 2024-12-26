import 'package:flutter/material.dart';
import 'api_service.dart';
import 'profile.dart';
import 'add_tiket_screen.dart';

class TicketListScreen extends StatefulWidget {
  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final _apiService = ApiService();
  List<dynamic> _tickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  // Show form to add new ticket
  void _addTicket() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTicketScreen()),
    );
  }

  void _loadTickets() async {
    try {
      final tickets = await _apiService.getTickets();
      setState(() {
        _tickets = tickets;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tickets: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              try {
                await _apiService.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successfully logged out')),
                );
                // Navigasi ke halaman login setelah logout berhasil
                Navigator.pushReplacementNamed(context, '/');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final ticket = _tickets[index];
          return ListTile(
            title: Text(ticket['problem']),
            subtitle: Text('Status: ${ticket['status']}'),
          );
        },
      ),
      floatingActionButton: Stack(
        children: [
          // Tombol untuk melihat profile
          Positioned(
            bottom: 10,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Icon(Icons.person),
              tooltip: 'View Profile',
            ),
          ),
          // Tombol untuk menambahkan tiket
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _addTicket, // Open AddTicketScreen
              tooltip: 'Add Ticket',
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
