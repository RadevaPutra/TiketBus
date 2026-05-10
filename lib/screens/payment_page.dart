import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final int selectedSeats;
  final double totalPrice;

  const PaymentPage({super.key, required this.selectedSeats, required this.totalPrice});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = "Transfer Bank";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(),
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
          _summaryRow("Harga per Kursi", "Rp 150.000"),
          _summaryRow("Biaya Layanan", "Rp 5.000"),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                "Rp ${(widget.totalPrice + 5000).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _showSuccessDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text("KONFIRMASI BAYAR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  void _showSuccessDialog() {
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E)),
                child: const Text("KEMBALI KE BERANDA", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
