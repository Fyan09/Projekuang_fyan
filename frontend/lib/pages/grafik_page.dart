import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'main_page.dart';
import 'package:intl/intl.dart';

class GrafikPage extends StatefulWidget {
  final List<Transaction> transactions;

  const GrafikPage({super.key, required this.transactions});

  @override
  State<GrafikPage> createState() => _GrafikPageState();
}

class _GrafikPageState extends State<GrafikPage> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = selectedDate == null
        ? widget.transactions
        : widget.transactions.where((txn) {
            return txn.date.year == selectedDate!.year &&
                txn.date.month == selectedDate!.month &&
                txn.date.day == selectedDate!.day;
          }).toList();

    double totalPemasukan = 0;
    double totalPengeluaran = 0;

    for (var txn in filteredTransactions) {
      if (txn.type == 'pemasukan') {
        totalPemasukan += txn.amount.toDouble();
      } else if (txn.type == 'pengeluaran') {
        totalPengeluaran += txn.amount.toDouble();
      }
    }

    final totalSemua = totalPemasukan + totalPengeluaran;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik Transaksi'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pickDate,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (selectedDate != null)
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  'Tanggal: ${DateFormat.yMMMMd().format(selectedDate!)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 35),
            Expanded(
              child: totalSemua == 0
                  ? const Center(
                      child: Text(
                        'Tidak ada data transaksi pada tanggal ini.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                              startDegreeOffset: -90,
                              sections: [
                                PieChartSectionData(
                                  value: totalPemasukan,
                                  color: Colors.green.shade400,
                                  radius: 80,
                                  title:
                                      '${((totalPemasukan / totalSemua) * 100).toStringAsFixed(1)}%',
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: totalPengeluaran,
                                  color: Colors.red.shade400,
                                  radius: 80,
                                  title:
                                      '${((totalPengeluaran / totalSemua) * 100).toStringAsFixed(1)}%',
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            swapAnimationDuration:
                                const Duration(milliseconds: 600),
                            swapAnimationCurve: Curves.easeInOut,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegend(
                                color: Colors.green.shade400,
                                label: 'Pemasukan'),
                            const SizedBox(width: 20),
                            _buildLegend(
                                color: Colors.red.shade400,
                                label: 'Pengeluaran'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            child: Column(
                              children: [
                                _buildSummaryRow('Total Pemasukan',
                                    totalPemasukan, Colors.green),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Total Pengeluaran',
                                    totalPengeluaran, Colors.red),
                                const Divider(height: 24),
                                _buildSummaryRow('Total Keseluruhan',
                                    totalSemua, Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 14),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildSummaryRow(String title, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: color)),
        Text(
          NumberFormat.currency(
                  locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
              .format(amount),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
