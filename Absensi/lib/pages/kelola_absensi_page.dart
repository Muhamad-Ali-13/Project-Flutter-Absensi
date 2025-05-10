import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class KelolaAbsensiPage extends StatefulWidget {
  @override
  _KelolaAbsensiPageState createState() => _KelolaAbsensiPageState();
}

class _KelolaAbsensiPageState extends State<KelolaAbsensiPage> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> laporanAbsensi = [];

  @override
  void initState() {
    super.initState();
    fetchLaporan();
  }

  void fetchLaporan() {
    // Simulasi ambil data absensi
    setState(() {
      laporanAbsensi = [
        {
          'nama': 'Budi',
          'tanggal': '2025-05-01',
          'status': 'Hadir',
        },
        {
          'nama': 'Siti',
          'tanggal': '2025-05-02',
          'status': 'Izin',
        },
      ];
    });
  }

  void pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        fetchLaporan(); // nanti disesuaikan filter API
      });
    }
  }

  void printLaporan() {
    Printing.layoutPdf(onLayout: (format) async {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Laporan Absensi Bulan ${DateFormat('MMMM yyyy').format(selectedDate)}'),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Nama', 'Tanggal', 'Status'],
                  data: laporanAbsensi.map((e) => [
                    e['nama'],
                    e['tanggal'],
                    e['status'],
                  ]).toList(),
                ),
              ],
            );
          },
        ),
      );

      return pdf.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bulanTahun = DateFormat('MMMM yyyy').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Absensi Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: printLaporan,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: pilihTanggal,
                  child: Text('Pilih Bulan/Tahun'),
                ),
                SizedBox(width: 10),
                Text(bulanTahun),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: laporanAbsensi.length,
              itemBuilder: (context, index) {
                final absen = laporanAbsensi[index];
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(absen['nama']),
                  subtitle: Text('Tanggal: ${absen['tanggal']} | Status: ${absen['status']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
