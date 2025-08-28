import 'package:flutter/material.dart';
import 'package:kasir_flutter_app/mobile/utils/constants.dart';
import 'package:kasir_flutter_app/mobile/screens/dashboard_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/obat_list_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/obat_form_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/auth_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),   // jangan ada AppBar di dalam file ini
    ObatListScreen(),
    ObatFormScreen(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Produk",
    "Tambah Produk",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack( // biar state antar halaman tidak hilang saat pindah tab
        index: _selectedIndex,
        children: _pages,
      ),

      // ===== NAVBAR BAWAH =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Tambah',
          ),
        ],
      ),
    );
  }
  
}
