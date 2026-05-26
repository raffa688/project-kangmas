import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import 'tukang_detail_screen.dart';
import 'user_orders_screen.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final List<String> categories = ['listrik', 'air', 'bangunan'];
  String selectedCategory = 'listrik';
  List<dynamic> recommendations = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    setState(() => isLoading = true);
    try {
      // Mock latitude and longitude for Telkom University
      final lat = -6.9730;
      final lng = 107.6307;
      
      final res = await ApiService.get(
          '/recommend?latitude=$lat&longitude=$lng&category=$selectedCategory');
          
      if (res['success']) {
        setState(() {
          recommendations = res['data'];
        });
      }
    } catch (e) {
      // FALLBACK TO DUMMY DATA FOR TESTING
      setState(() {
        recommendations = [
          {
            'user_id': 101,
            'name': 'Budi Listrik',
            'avg_rating': 4.8,
            'total_reviews': 24,
            'distance_km': 1.2,
            'base_price': 50000,
            'category': 'listrik'
          },
          {
            'user_id': 102,
            'name': 'Agus Pompa',
            'avg_rating': 4.5,
            'total_reviews': 15,
            'distance_km': 2.5,
            'base_price': 75000,
            'category': 'air'
          },
          {
            'user_id': 103,
            'name': 'Slamet Bangun',
            'avg_rating': 4.9,
            'total_reviews': 40,
            'distance_km': 0.8,
            'base_price': 100000,
            'category': 'bangunan'
          },
        ].where((t) => t['category'] == selectedCategory).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server tidak terhubung. Menggunakan data simulasi.'), duration: Duration(seconds: 2)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        title: const Text('KANGMAS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserOrdersScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cari Tukang Profesional',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Solusi cepat untuk segala urusan rumah Anda.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          
          // Category Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kategori Layanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Lihat Semua', style: TextStyle(color: Colors.amber.shade800, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((cat) {
                final isSelected = cat == selectedCategory;
                IconData icon;
                switch (cat) {
                  case 'listrik': icon = Icons.electrical_services; break;
                  case 'air': icon = Icons.water_drop; break;
                  case 'bangunan': icon = Icons.construction; break;
                  default: icon = Icons.build;
                }
                
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedCategory = cat);
                    _fetchRecommendations();
                  },
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.amber.shade700 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: isSelected ? Colors.white : Colors.amber.shade700, size: 30),
                        const SizedBox(height: 8),
                        Text(
                          cat.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Rekomendasi Tukang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : recommendations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            const Text('Tidak ada tukang ditemukan di sekitar Anda.'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          final tukang = recommendations[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => TukangDetailScreen(tukangId: tukang['user_id'])),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            tukang['name'][0],
                                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber.shade700),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tukang['name'],
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.star, size: 16, color: Colors.orange),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${tukang['avg_rating']} (${tukang['total_reviews']})',
                                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                                ),
                                                const SizedBox(width: 12),
                                                const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${tukang['distance_km']} km',
                                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Mulai dari Rp ${tukang['base_price']}',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade800),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.grey),
                                    ],
                                  ),
                                ),
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
