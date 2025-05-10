import 'package:flutter/material.dart';

// Import pages
import '../pages/admin/dashboard_admin_page.dart';
import '../pages/admin/user/user_page.dart';
import '../pages/admin/siswa/siswa_page.dart';
import '../pages/admin/guru/guru_page.dart';
import '../pages/admin/kelas/kelas_page.dart';
import '../pages/admin/mapel/mata_pelajaran_page.dart';
import '../pages/admin/jadwal/jadwal_pembelajaran_page.dart';
import '../pages/admin/absensi/absensi_page.dart';
import '../../../pages/kelola_absensi_page.dart'; // Added import for KelolaAbsensiPage
import '../pages/profile_page.dart';
import 'top_navbar.dart';

class MainLayout extends StatefulWidget {
  final String role;
  const MainLayout({Key? key, required this.role}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _items;

  @override
  void initState() {
    super.initState();
    if (widget.role == 'admin') {
      _pages = [
        DashboardAdminPage(),
        MasterMenuPage(), // <--- Ini Master Menu Page baru
        KelolaAbsensiPage(),
        ProfilPage(), // opsional
      ];
      _items = [
        const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Master'),
        const BottomNavigationBarItem(icon: Icon(Icons.how_to_reg), label: 'Absensi'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    } else {
      // Role user biasa
      _pages = [
        ProfilPage(), // Hanya profil untuk user biasa
      ];
      _items = [
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavbar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// ============================
// Ini halaman MasterMenuPage baru
// ============================

class MasterMenuPage extends StatelessWidget {
  const MasterMenuPage({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCard(context, Icons.admin_panel_settings, 'User', const UserPage()),
          _buildCard(context, Icons.person, 'Guru', const GuruPage()),
          _buildCard(context, Icons.class_, 'Kelas', const KelasPage()),
          _buildCard(context, Icons.school, 'Siswa', const SiswaPage()),
          _buildCard(context, Icons.book, 'Mapel', const MataPelajaranPage()),
          _buildCard(context, Icons.schedule, 'Jadwal', const JadwalPembelajaranPage()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, Widget page) {
    return InkWell(
      onTap: () => _navigateTo(context, page),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
