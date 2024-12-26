import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:frontend_helpdesk/widgets/navbar.dart';
import '../constants/api_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<TicketData> ticketData = [];

  @override
  void initState() {
    super.initState();
    fetchTicketData();
  }

  Future<void> fetchTicketData() async {
    final apiService = ApiService();
    final data = await apiService.getTickets(page: 1);
    // Assuming the API returns monthly data for 'on_progress' and 'done' ticket counts
    List<TicketData> tempData = [];
    // You should adjust based on actual data structure from API
    for (int i = 0; i < 12; i++) {
      tempData.add(TicketData(
        month: i + 1,
        onProgress: data['status_counts']['on_progress'] ?? 0,
        done: data['status_counts']['done'] ?? 0,
      ));
    }

    setState(() {
      ticketData = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Home",
        searchBar: false,
        categoryOne: "List Tiket",
        categoryTwo: "Add Tiket",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Monitoring Tiket',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            ticketData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: 'Status'),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Ticket Count'),
                      ),
                      series: <CartesianSeries>[
                        BarSeries<TicketData, String>(
                          dataSource: ticketData,
                          xValueMapper: (TicketData data, _) =>
                              ' ${data.month}',
                          yValueMapper: (TicketData data, _) => data.onProgress,
                          name: 'On Progress',
                          color: Colors.blue,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          dataLabelMapper: (TicketData data, _) {
                            // Cast to double for accurate percentage calculation
                            double total = data.onProgress.toDouble() +
                                data.done.toDouble();
                            double percentage = (total == 0)
                                ? 0
                                : (data.onProgress.toDouble() / total) * 100;
                            return '${data.onProgress} (${percentage.toStringAsFixed(1)}%)';
                          },
                        ),
                        BarSeries<TicketData, String>(
                          dataSource: ticketData,
                          xValueMapper: (TicketData data, _) =>
                              ' ${data.month}',
                          yValueMapper: (TicketData data, _) => data.done,
                          name: 'Done',
                          color: Colors.green,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          dataLabelMapper: (TicketData data, _) {
                            // Cast to double for accurate percentage calculation
                            double total = data.onProgress.toDouble() +
                                data.done.toDouble();
                            double percentage = (total == 0)
                                ? 0
                                : (data.done.toDouble() / total) * 100;
                            return '${data.done} (${percentage.toStringAsFixed(1)}%)';
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class TicketData {
  final int month;
  final int onProgress;
  final int done;

  TicketData({
    required this.month,
    required this.onProgress,
    required this.done,
  });
}
