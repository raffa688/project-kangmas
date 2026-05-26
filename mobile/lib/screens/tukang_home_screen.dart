import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class TukangHomeScreen extends StatefulWidget {
  @override
  _TukangHomeScreenState createState() => _TukangHomeScreenState();
}

class _TukangHomeScreenState extends State<TukangHomeScreen> {
  bool isActive = false;
  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    isActive = auth.user?.tukangProfile?.isActive ?? false;
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final res = await ApiService.get('/orders');
      if (res['success']) {
        final List data = res['data']['data']; 
        setState(() {
          orders = data.map((e) => OrderModel.fromJson(e)).toList();
        });
      }
    } catch (e) {
      // FALLBACK TO DUMMY DATA
      setState(() {
        orders = [
          OrderModel(
            id: 10,
            userId: 1,
            tukangId: 101,
            description: 'Pemasangan stop kontak baru',
            status: 'pending',
            createdAt: '2026-05-06',
            user: UserModel(id: 1, name: 'Raffa (Pelanggan)', email: '', role: 'user', phoneNumber: '08123445566'),
          ),
          OrderModel(
            id: 11,
            userId: 2,
            tukangId: 101,
            description: 'Lampu teras mati total',
            status: 'accepted',
            createdAt: '2026-05-06',
            user: UserModel(id: 2, name: 'Siti (Pelanggan)', email: '', role: 'user', phoneNumber: '0855667788'),
          ),
        ];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mode Offline: Menggunakan daftar kerja simulasi.')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _toggleActive() async {
    try {
      final res = await ApiService.patch('/tukang/toggle-active');
      if (res['success']) {
        setState(() {
          isActive = res['data']['is_active'];
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _updateOrderStatus(int id, String status, {int? price}) async {
    try {
      final Map<String, dynamic> body = {'status': status};
      if (price != null) body['total_price'] = price;

      final res = await ApiService.put('/orders/$id', body);
      if (res['success']) {
        _fetchOrders();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status pesanan diperbarui')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _showCompleteDialog(int orderId) async {
    final _priceCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selesaikan Pesanan'),
          content: TextField(
            controller: _priceCtl,
            decoration: const InputDecoration(labelText: 'Total Biaya (Rp)'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = int.tryParse(_priceCtl.text);
                if (price != null && price > 0) {
                  Navigator.pop(context);
                  _updateOrderStatus(orderId, 'completed', price: price);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap masukkan harga yang valid')));
                }
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openWhatsApp(String phone) async {
    String formattedPhone = phone;
    if (phone.startsWith('0')) {
      formattedPhone = '62${phone.substring(1)}';
    }
    final url = Uri.parse('https://wa.me/$formattedPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka WhatsApp')));
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Dashboard Tukang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Header Status
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.user?.name ?? 'Tukang',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rating: ⭐ ${auth.user?.tukangProfile?.avgRating ?? 0} | ${auth.user?.tukangProfile?.category.toUpperCase()}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        isActive ? 'ONLINE' : 'OFFLINE',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: isActive,
                        onChanged: (val) => _toggleActive(),
                        activeColor: Colors.greenAccent,
                        activeTrackColor: Colors.white24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.assignment_outlined, color: Colors.amber),
                const SizedBox(width: 8),
                const Text('Daftar Pekerjaan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
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
                            Icon(Icons.work_off_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            const Text('Belum ada pesanan masuk.'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          Color statusColor = Colors.grey;
                          if (order.status == 'pending') statusColor = Colors.orange;
                          if (order.status == 'accepted') statusColor = Colors.blue;
                          if (order.status == 'completed') statusColor = Colors.green;
                          if (order.status == 'cancelled') statusColor = Colors.red;

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
                                      Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          order.status.toUpperCase(),
                                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    children: [
                                      Icon(Icons.person_outline, size: 18, color: Colors.grey.shade600),
                                      const SizedBox(width: 8),
                                      Text('Pelanggan: ${order.user?.name ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.report_problem_outlined, size: 18, color: Colors.grey.shade600),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text('Kendala: ${order.description}', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  if (order.totalPrice != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      'Total Biaya: Rp ${order.totalPrice}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber.shade900),
                                    ),
                                  ],
                                  
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (order.status == 'pending' || order.status == 'accepted')
                                        OutlinedButton.icon(
                                          icon: const Icon(Icons.chat, size: 18),
                                          label: const Text('Hubungi WA'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.green,
                                            side: const BorderSide(color: Colors.green),
                                          ),
                                          onPressed: () => _openWhatsApp(order.user?.phoneNumber ?? ''),
                                        ),
                                      const SizedBox(width: 8),
                                      if (order.status == 'pending')
                                        ElevatedButton(
                                          onPressed: () => _updateOrderStatus(order.id, 'accepted'),
                                          child: const Text('Terima Order'),
                                        ),
                                      if (order.status == 'accepted')
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                          onPressed: () => _showCompleteDialog(order.id),
                                          child: const Text('Selesaikan', style: TextStyle(color: Colors.white)),
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
