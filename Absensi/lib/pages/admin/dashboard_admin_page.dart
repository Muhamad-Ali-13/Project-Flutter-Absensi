import 'package:flutter/material.dart';
import '../../models/dashboard.dart';
import '../../services/api_service.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({Key? key}) : super(key: key);

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  late Future<Dashboard> _futureDashboard;

  @override
  void initState() {
    super.initState();
    _futureDashboard = ApiService.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1000;

    double childAspectRatio = isMobile
        ? 1 / 1.2
        : isTablet
        ? 1 / 1.4
        : 1 / 1.6;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Dashboard>(
            future: _futureDashboard,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Terjadi kesalahan pada server'));
              }

              final data = snapshot.data!;

              final items = [
                _DashboardItem('Total User', data.totalUser, Icons.person, Colors.blue),
                _DashboardItem('Total Siswa', data.totalSiswa, Icons.school, Colors.green),
                _DashboardItem('Total Guru', data.totalGuru, Icons.badge, Colors.purple),
                _DashboardItem('Absensi Hari Ini', data.totalAbsensiHariIni, Icons.event_available, Colors.orange),
              ];

              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: isMobile ? 200 : 250,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildCard(item, isMobile);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(_DashboardItem item, bool isMobile) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, size: isMobile ? 36 : 40, color: item.color),
            const SizedBox(height: 12),
            Text(
              item.value.toString(),
              style: TextStyle(
                fontSize: isMobile ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: item.color,
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  _DashboardItem(this.title, this.value, this.icon, this.color);
}
