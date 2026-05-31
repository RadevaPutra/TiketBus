import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasBooking = AuthService().hasActiveBooking;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan Saya"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: hasBooking ? _buildBookingsList() : _buildEmptyState(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("Belum Ada Pesanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Tiket yang Anda pesan akan muncul di sini.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    final bookings = AuthService().activeBookings;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(booking.busName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("ID Booking: ${booking.id}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 5),
                Text("Tanggal: ${booking.date}", style: const TextStyle(color: Colors.indigo, fontSize: 13, fontWeight: FontWeight.bold)),
                Text("Kursi: ${booking.seatNumbers.join(', ')}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Keberangkatan", style: TextStyle(color: Colors.grey)),
                          Text(booking.origin, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.arrow_forward, color: Colors.orange),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Tujuan", style: TextStyle(color: Colors.grey)),
                          Text(booking.destination, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
