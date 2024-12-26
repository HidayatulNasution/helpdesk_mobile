import 'package:flutter/material.dart';
import 'package:frontend_helpdesk/constants/Theme.dart';
import '../constants/api_service.dart';
import 'package:frontend_helpdesk/widgets/navbar.dart';
import 'package:frontend_helpdesk/widgets/drawer.dart';

class ListTiket extends StatefulWidget {
  @override
  State<ListTiket> createState() => _ListTiketState();
}

class _ListTiketState extends State<ListTiket> {
  final _apiService = ApiService();
  List<dynamic> _tickets = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  int? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() async {
    if (_isLoading || _currentPage > _totalPages) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.paginates(
        page: _currentPage,
        status: _filterStatus,
      );
      setState(() {
        _tickets = _currentPage == 1
            ? response['tiket'] ?? []
            : [..._tickets, ...response['tiket']];
        _currentPage = response['pagination']['current_page'] ?? 1;
        _totalPages = response['pagination']['total_pages'] ?? 1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tickets: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setFilterStatus(int? status) {
    setState(() {
      _filterStatus = status;
      _currentPage = 1;
      _totalPages = 1;
      _tickets = [];
    });
    _loadTickets();
  }

  void _showDetailModal(BuildContext context, Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Heading untuk Detail Tiket
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Detail Tiket",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent, // Warna heading
                  ),
                ),
              ),
              // Divider dengan margin
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  thickness: 2, // Ketebalan divider
                  color: Colors.blueAccent, // Warna divider
                ),
              ),
              // Informasi Problem
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Problem: ${ticket['problem'] ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87, // Warna teks
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Tombol Close
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Warna tombol
                      foregroundColor: Colors.white, // Warna teks tombol
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // Padding tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Membuat tombol melengkung
                      ),
                    ),
                    child: Text(
                      "Close",
                      style: TextStyle(fontSize: 16), // Ukuran teks tombol
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.0,
      children: [
        ChoiceChip(
          label: Text("All"),
          selected: _filterStatus == null,
          onSelected: (_) => _setFilterStatus(null),
          selectedColor: Colors.blue,
        ),
        ChoiceChip(
          label: Text("On Progress"),
          selected: _filterStatus == 0,
          onSelected: (_) => _setFilterStatus(0),
          selectedColor: Colors.purple,
        ),
        ChoiceChip(
          label: Text("Done"),
          selected: _filterStatus == 1,
          onSelected: (_) => _setFilterStatus(1),
          selectedColor: Colors.green,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.black : ArgonColors.bgColorScreen;

    return Scaffold(
      appBar: Navbar(
        title: "List Tiket",
        searchBar: false,
        categoryOne: "List Tiket",
        categoryTwo: "Add Tiket",
      ),
      backgroundColor: bgColor,
      drawer: ArgonDrawer(currentPage: "List Tiket"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildFilterChips(),
          ),
          Expanded(
            child: _tickets.isEmpty && !_isLoading
                ? Center(
                    child: Text(
                      "Tidak ada tiket untuk ditampilkan",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tickets.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _tickets.length) {
                        return _currentPage < _totalPages
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _loadTickets,
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text('Load More'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              )
                            : SizedBox(); // Hide button if all pages are loaded
                      }
                      final ticket = _tickets[index];
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: ticket['status'] == 0
                                ? Colors.orange
                                : Colors.green,
                            child: Icon(
                              ticket['status'] == 0
                                  ? Icons.work_outline
                                  : Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            ticket['bidang_system'] ?? 'N/A',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kategori: ${ticket['kategori'] ?? 'N/A'}'),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    'Status: ${ticket['status'] == 0 ? "On Progress" : "Done"}',
                                    style: TextStyle(
                                      color: ticket['status'] == 0
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_horiz,
                                color: ArgonColors.primary),
                            onPressed: () => _showDetailModal(context, ticket),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
