import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'create_order_screen.dart';

class TukangDetailScreen extends StatefulWidget {
  final int tukangId;

  const TukangDetailScreen({Key? key, required this.tukangId}) : super(key: key);

  @override
  _TukangDetailScreenState createState() => _TukangDetailScreenState();
}

class _TukangDetailScreenState extends State<TukangDetailScreen> {
  Map<String, dynamic>? tukangData;
  Map<String, dynamic>? reviewData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final tRes = await ApiService.get('/tukang/${widget.tukangId}');
      final rRes = await ApiService.get('/reviews/tukang/${widget.tukangId}');
      
      if (tRes['success'] && rRes['success']) {
        setState(() {
          tukangData = tRes['data'];
          reviewData = rRes['data'];
          isLoading = false;
        });
      }
    } catch (e) {
    } catch (e) {
      // FALLBACK TO DUMMY DATA
      setState(() {
        tukangData = {
          'id': widget.tukangId,
          'category': widget.tukangId == 101 ? 'listrik' : 'air',
          'address': 'Jl. Sukabirus No. 12, Bandung',
          'base_price': 50000,
          'avg_rating': 4.8,
          'total_reviews': 12,
          'user': {
            'id': widget.tukangId,
            'name': widget.tukangId == 101 ? 'Budi Listrik' : 'Agus Pompa',
            'phone_number': '08123456789',
          }
        };
        reviewData = {
          'reviews': [
            {
              'rating': 5,
              'comment': 'Sangat cepat dan rapi kerjanya!',
              'user': {'name': 'Raffa'}
            },
            {
              'rating': 4,
              'comment': 'Harganya terjangkau.',
              'user': {'name': 'Siti'}
            }
          ]
        };
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mode Offline: Menggunakan detail simulasi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade700,
          title: const Text('Detail Tukang', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final t = tukangData!;
    final user = t['user'];
    final reviews = reviewData!['reviews'] as List;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        title: Text(user['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user['name'][0],
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.amber.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t['category'].toString().toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informasi Kontak', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.phone_android, 'No HP', user['phone_number']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.location_on_outlined, 'Alamat', t['address']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.payments_outlined, 'Harga Dasar', 'Rp ${t['base_price']}'),
                  
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '${t['avg_rating']} / 5.0',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${t['total_reviews']} ulasan)',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateOrderScreen(
                            tukangId: user['id'],
                            tukangName: user['name'],
                            category: t['category'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('PESAN JASA SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 40),
                  const Text('Ulasan Pelanggan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(height: 32),
                  
                  if (reviews.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('Belum ada ulasan.', style: TextStyle(color: Colors.grey.shade500)),
                      ),
                    )
                  else
                    ...reviews.map((r) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r['user']['name'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: List.generate(5, (index) => Icon(
                                  Icons.star,
                                  size: 14,
                                  color: index < (r['rating'] ?? 0) ? Colors.orange : Colors.grey.shade300,
                                )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(r['comment'] ?? 'Tanpa komentar.', style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                    )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber.shade800, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        ),
      ],
    );
  }
}
