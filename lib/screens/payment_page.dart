import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/booking_model.dart';
import 'login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bus_tracking_page.dart';

class PaymentPage extends StatefulWidget {
  final int selectedSeats;
  final double totalPrice;
  final String busName;
  final String origin;
  final String destination;
  final String date;
  final List<String> seatNumbers;

  const PaymentPage({
    super.key, 
    required this.selectedSeats, 
    required this.totalPrice,
    required this.busName,
    required this.origin,
    required this.destination,
    required this.date,
    required this.seatNumbers,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = "Transfer Bank";
  final TextEditingController _promoController = TextEditingController();
  double _discountAmount = 0.0;
  String _appliedPromo = "";

  void _applyPromo() {
    String code = _promoController.text.trim().toUpperCase();
    if (code == "HEMAT30") {
      setState(() {
        _discountAmount = widget.totalPrice * 0.3; // 30% off
        _appliedPromo = "HEMAT30";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Promo Liburan Hemat 30% Berhasil Digunakan!"), backgroundColor: Colors.green));
    } else if (code == "DISKON50K") {
      setState(() {
        _discountAmount = 50000;
        _appliedPromo = "DISKON50K";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Voucher Bus Rp 50.000 Berhasil Digunakan!"), backgroundColor: Colors.green));
    } else {
      setState(() {
        _discountAmount = 0;
        _appliedPromo = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode promo tidak valid."), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AuthService().isLoggedIn
                ? _buildUserMenu(context)
                : TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      if (result == true) {
                        setState(() {});
                      }
                    },
                    child: const Text("Masuk", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ),
          ),
        ],
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 20),
                _buildPromoSection(),
                const SizedBox(height: 30),
                const Text("Pilih Metode Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                const SizedBox(height: 20),
                _buildPaymentMethod("Transfer Bank", Icons.account_balance_rounded, "BCA, Mandiri, BNI, BRI"),
                _buildPaymentMethod("E-Wallet", Icons.account_balance_wallet_rounded, "GoPay, OVO, Dana, LinkAja"),
                _buildPaymentMethod("Kartu Kredit", Icons.credit_card_rounded, "Visa, Mastercard, JCB"),
                const SizedBox(height: 40),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: Color(0xFF1A237E)),
              SizedBox(width: 10),
              Text("Ringkasan Pesanan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 30),
          _summaryRow("Jumlah Kursi", "${widget.selectedSeats} Kursi"),
          _summaryRow("Harga per Kursi", "Rp ${(widget.totalPrice / (widget.selectedSeats == 0 ? 1 : widget.selectedSeats)).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}"),
          _summaryRow("Biaya Layanan", "Rp 5.000"),
          if (_discountAmount > 0)
            _summaryRow("Diskon Promo", "- Rp ${_discountAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}", color: Colors.green),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                "Rp ${((widget.totalPrice + 5000) - _discountAmount < 0 ? 0 : (widget.totalPrice + 5000) - _discountAmount).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gunakan Promo Spesial", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  onChanged: (value) {
                    if (value.trim().toUpperCase() == "HEMAT30" || value.trim().toUpperCase() == "DISKON50K") {
                      _applyPromo();
                    } else if (_appliedPromo.isNotEmpty) {
                      setState(() {
                        _discountAmount = 0.0;
                        _appliedPromo = "";
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Contoh: HEMAT30 / DISKON50K",
                    filled: true,
                    fillColor: const Color(0xFFF5F7FB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _applyPromo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Terapkan", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (_appliedPromo.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text("✅ Kode $_appliedPromo sedang digunakan", style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon, String subtitle) {
    bool isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A237E).withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? const Color(0xFF1A237E) : const Color(0xFFEEEEEE), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1A237E), size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: Color(0xFF1A237E)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    double finalPrice = (widget.totalPrice + 5000) - _discountAmount;
    if (finalPrice < 0) finalPrice = 0;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          final String bookingId = "BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
          
          Booking newBooking = Booking(
            id: bookingId,
            busName: widget.busName,
            origin: widget.origin,
            destination: widget.destination,
            date: widget.date,
            selectedSeatsCount: widget.selectedSeats,
            seatNumbers: widget.seatNumbers,
            totalPrice: finalPrice,
          );
          
          AuthService().addBooking(newBooking);
          
          _sendToWhatsAppAdmin(bookingId, finalPrice);
          _showSuccessDialog(bookingId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text("BAYAR RP ${finalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  void _sendToWhatsAppAdmin(String bookingId, double totalAmount) async {
    const String phoneNumber = "+6281933053869";
    final String userName = AuthService().userName ?? "Pengguna";
    
    // Generate a dummy Booking ID and Link for professional look
    final String ticketLink = "https://tiketbus.com/tix/$bookingId";
    
    String promoText = _appliedPromo.isNotEmpty ? "\nPromo Digunakan: $_appliedPromo (Diskon Rp ${_discountAmount.toStringAsFixed(0)})" : "";

    final String message = "Halo Admin TiketBus,\n\n"
        "Saya ingin konfirmasi booking tiket:\n"
        "ID Booking: $bookingId\n"
        "Nama: $userName\n"
        "Jumlah Kursi: ${widget.selectedSeats}$promoText\n"
        "Metode Pembayaran: $_selectedMethod\n"
        "Total Pembayaran: Rp ${totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}\n\n"
        "Bukti Tiket: $ticketLink\n\n"
        "Mohon segera dikonfirmasi. Terima kasih!";

    final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak bisa membuka WhatsApp")),
      );
    }
  }

  void _showSuccessDialog(String bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Pembayaran Berhasil!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Tiket Anda telah dikirim ke email.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BusTrackingPage(
                    busName: widget.busName,
                    bookingId: bookingId,
                    origin: widget.origin,
                    destination: widget.destination,
                  )));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black87),
                child: const Text("LACAK BUS SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF1A237E))),
                child: const Text("KEMBALI KE BERANDA", style: TextStyle(color: Color(0xFF1A237E))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          setState(() {
            AuthService().logout();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Berhasil Keluar"), backgroundColor: Colors.indigo),
          );
        }
      },
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.amber,
                child: Icon(Icons.person, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AuthService().userName ?? "User",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Text(
                    "Terverifikasi",
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.indigo),
              SizedBox(width: 10),
              Text("Profil Saya"),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 10),
              Text("Keluar", style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.amber,
        child: Icon(Icons.person, color: Colors.black87, size: 20),
      ),
    );
  }
}
