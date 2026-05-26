import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import 'review_screen.dart';

class UserOrdersScreen extends StatefulWidget {
  @override
  _UserOrdersScreenState createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final res = await ApiService.get('/orders');
      if (res['success']) {
        final List data = res['data']['data']; // paginated response structure
        setState(() {
          orders = data.map((e) => OrderModel.fromJson(e)).toList();
        });
      }
    } catch (e) {
      // FALLBACK TO DUMMY DATA
      setState(() {
        orders = [
          OrderModel(
            id: 1,
            userId: 99,
            tukangId: 101,
            description: 'Perbaikan instalasi lampu ruang tamu',
            status: 'completed',
            totalPrice: 150000,
            createdAt: '2026-05-05',
            tukang: UserModel(id: 101, name: 'Budi Listrik', email: '', role: 'tukang', phoneNumber: '08123456789'),
          ),
          OrderModel(
            id: 2,
            userId: 99,
            tukangId: 102,
            description: 'Kran air dapur patah',
            status: 'pending',
            createdAt: '2026-05-06',
            tukang: UserModel(id: 102, name: 'Agus Pompa', email: '', role: 'tukang', phoneNumber: '08987654321'),
          ),
        ];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menggunakan data pesanan simulasi.')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _cancelOrder(int id) async {
    try {
      final res = await ApiService.put('/orders/$id', {'status': 'cancelled'});
      if (res['success']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan dibatalkan')));
        _fetchOrders();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    // Basic format assuming phone starts with 0 or 62
    String formattedPhone = phone;
    if (phone.startsWith('0')) {
      formattedPhone = '62${phone.substring(1)}';
    }
    final url = Uri.parse('https://wa.me/$formattedPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka WhatsApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Pesanan Saya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          // Clear Logout button to help verify Login screen UI
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout to see Login Screen',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: Colors.amber.shade700,
            child: const Text(
              'Riwayat layanan tukang Anda',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            const Text('Belum ada pesanan.'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          Color statusColor = Colors.grey;
                          IconData statusIcon = Icons.hourglass_empty;
                          
                          if (order.status == 'pending') {
                            statusColor = Colors.orange;
                            statusIcon = Icons.pending_actions;
                          } else if (order.status == 'accepted') {
                            statusColor = Colors.blue;
                            statusIcon = Icons.check_circle_outline;
                          } else if (order.status == 'completed') {
                            statusColor = Colors.green;
                            statusIcon = Icons.verified;
                          } else if (order.status == 'cancelled') {
                            statusColor = Colors.red;
                            statusIcon = Icons.cancel_outlined;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(statusIcon, color: statusColor, size: 18),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Order #${order.id}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: statusColor.withOpacity(0.5)),
                                        ),
                                        child: Text(
                                          order.status.toUpperCase(),
                                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Text(
                                    'Tukang: ${order.tukang?.name ?? '-'}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kendala: ${order.description}',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                  ),
                                  if (order.totalPrice != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      'Total Harga: Rp ${order.totalPrice}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber.shade900),
                                    ),
                                  ],
                                  
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (order.status != 'cancelled' && order.status != 'completed')
                                        OutlinedButton.icon(
                                          icon: const Icon(Icons.chat, size: 18),
                                          label: const Text('Chat WA'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.green,
                                            side: const BorderSide(color: Colors.green),
                                          ),
                                          onPressed: () => _openWhatsApp(order.tukang?.phoneNumber ?? ''),
                                        ),
                                      const SizedBox(width: 8),
                                      if (order.status == 'pending')
                                        TextButton(
                                          onPressed: () => _cancelOrder(order.id),
                                          child: const Text('Batalkan', style: TextStyle(color: Colors.red)),
                                        ),
                                      if (order.status == 'completed')
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) => ReviewScreen(orderId: order.id, tukangName: order.tukang?.name ?? 'Tukang')),
                                            ).then((_) => _fetchOrders());
                                          },
                                          child: const Text('Beri Ulasan'),
                                        ),
                                    ],
                                  )
                                ],
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
