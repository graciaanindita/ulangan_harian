import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechExpres',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainNavigationPage(),
      },
    );
  }
}

// -----------------------------------------------------------------------------
// 1. HALAMAN LOGIN 
// -----------------------------------------------------------------------------
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gracia Anindita'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.devices,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang di TechExpres',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  child: const Text('Masuk Aplikasi', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. HALAMAN UTAMA / NAVIGATION BAR (Katalog & User Profil)
// -----------------------------------------------------------------------------
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CatalogPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Katalog'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User Profil'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. TAB KATALOG GADGET 
// -----------------------------------------------------------------------------
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  final List<Map<String, dynamic>> gadgets = const [
    {
      'nama': 'Smartphone Pro X',
      'kategori': 'Handphone',
      'hargaAsli': 8500000,
      'hargaTeks': 'Rp 8.500.000',
      'deskripsi': 'Smartphone flagship dengan kamera jernih dan performa tinggi.',
    },
    {
      'nama': 'Laptop Ultra Slim',
      'kategori': 'Komputer',
      'hargaAsli': 12000000,
      'hargaTeks': 'Rp 12.000.000',
      'deskripsi': 'Laptop tipis dan ringan untuk produktivitas sehari-hari.',
    },
    {
      'nama': 'Wireless Earbuds',
      'kategori': 'Aksesori',
      'hargaAsli': 750000,
      'hargaTeks': 'Rp 750.000',
      'deskripsi': 'Earbuds nirkabel dengan suara jernih dan bass mendalam.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TechExpres - Katalog'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: gadgets.length,
        itemBuilder: (context, index) {
          final gadget = gadgets[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailGadgetPage(
                    nama: gadget['nama']!,
                    kategori: gadget['kategori']!,
                    hargaAsli: gadget['hargaAsli']!,
                    hargaTeks: gadget['hargaTeks']!,
                    deskripsi: gadget['deskripsi']!,
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                  child: const Icon(Icons.devices, color: Colors.white),
                ),
                title: Text(
                  gadget['nama']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(gadget['hargaTeks']!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. HALAMAN DETAIL GADGET (Dengan Potongan Harga Otomatis)
// -----------------------------------------------------------------------------
class DetailGadgetPage extends StatefulWidget {
  final String nama;
  final String kategori;
  final int hargaAsli;
  final String hargaTeks;
  final String deskripsi;

  const DetailGadgetPage({
    super.key,
    required this.nama,
    required this.kategori,
    required this.hargaAsli,
    required this.hargaTeks,
    required this.deskripsi,
  });

  @override
  State<DetailGadgetPage> createState() => _DetailGadgetState();
}

class _DetailGadgetState extends State<DetailGadgetPage> {
  String statusVoucher = 'Belum diklaim';
  late int hargaSekarang;

  @override
  void initState() {
    super.initState();
    hargaSekarang = widget.hargaAsli; // Harga awal sebelum diskon
  }

  // Fungsi untuk mengubah angka integer ke format Rupiah (misal: 7650000 -> Rp 7.650.000)
  String formatRupiah(int angka) {
    return 'Rp ${angka.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nama)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.blue.shade50,
              child: const Icon(
                Icons.devices,
                size: 90,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(widget.kategori),
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 8),
            // Tampilan Harga (Akan berubah terpotong jika voucher diklaim)
            Text(
              formatRupiah(hargaSekarang),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Voucher Diskon:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              statusVoucher,
              style: TextStyle(
                fontSize: 15,
                color: statusVoucher == 'Belum diklaim' ? Colors.grey : Colors.deepOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () async {
                  final hasilVoucher = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PilihVoucherPage(),
                    ),
                  );

                  // Jika user memilih voucher, hitung potongan harganya
                  if (hasilVoucher != null) {
                    setState(() {
                      statusVoucher = 'Berhasil diklaim: $hasilVoucher';
                      
                      if (hasilVoucher == 'Diskon 10%') {
                        hargaSekarang = (widget.hargaAsli * (100 - 10) ~/ 100);
                      } else if (hasilVoucher == 'Diskon 20%') {
                        hargaSekarang = (widget.hargaAsli * (100 - 20) ~/ 100);
                      } else if (hasilVoucher == 'Diskon 30%') {
                        hargaSekarang = (widget.hargaAsli * (100 - 30) ~/ 100);
                      }
                    });
                  }
                },
                child: const Text('Klaim Voucher Diskon'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(widget.deskripsi, style: const TextStyle(fontSize: 14, height: 1.4)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. HALAMAN PILIH VOUCHER 
// -----------------------------------------------------------------------------
class PilihVoucherPage extends StatelessWidget {
  const PilihVoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> daftarVoucher = ['Diskon 10%', 'Diskon 20%', 'Diskon 30%'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Voucher'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarVoucher.length,
        itemBuilder: (context, index) {
          final voucher = daftarVoucher[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.blue),
              title: Text(voucher, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context, voucher);
              },
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6. TAB TECHEXPRES PROFIL 
// -----------------------------------------------------------------------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TechExpres Profil'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cicii',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('cicii@techexpres.com'),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Kode Member:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Card(
              child: ListTile(
                leading: Icon(Icons.card_membership, color: Colors.blue),
                title: Text('MEMBER-TECH-9988'),
                subtitle: Text('Gunakan untuk klaim voucher diskon'),
                trailing: Text('Aktif', style: TextStyle(color: Colors.green)),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout / Keluar'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}