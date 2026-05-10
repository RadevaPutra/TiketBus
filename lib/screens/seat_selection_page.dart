import 'package:flutter/material.dart';
import '../models/seat_model.dart';
import '../services/api_service.dart';
import 'payment_page.dart';

class SeatSelectionPage extends StatefulWidget {
  final String originCity;
  final String destinationCity;
  final String busName;

  const SeatSelectionPage({
    super.key,
    required this.originCity,
    required this.destinationCity,
    required this.busName,
  });

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final ApiService apiService = ApiService();
  List<Seat> seats = List.generate(24, (index) {
    int row = (index / 4).floor() + 1;
    String col = String.fromCharCode(65 + (index % 4));
    return Seat(id: index.toString(), label: '$row$col');
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Pilih Kursi",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E), // Deep Indigo
              Color(0xFF3949AB), // Indigo
              Color(0xFF5C6BC0), // Light Indigo
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildBusInfoHeader(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildLegend(),
                      const SizedBox(height: 20),
                      const Text(
                        "BAGIAN DEPAN BUS",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 2, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 1,
                          ),
                          itemCount: seats.length,
                          itemBuilder: (context, index) => _buildSeatItem(index),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusInfoHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn("Dari", widget.originCity),
              const Icon(Icons.swap_horiz, color: Colors.white70, size: 30),
              _infoColumn("Tujuan", widget.destinationCity, crossAxisAlignment: CrossAxisAlignment.end),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_bus, color: Colors.amber, size: 18),
                SizedBox(width: 8),
                Text(
                  "${widget.busName} • 12 Mei 2024",
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSeatItem(int index) {
    bool isSelected = seats[index].isSelected;
    bool isAvailable = seats[index].isAvailable;

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          setState(() => seats[index].isSelected = !seats[index].isSelected);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: !isAvailable 
              ? const Color(0xFFE0E0E0) 
              : isSelected 
                  ? const Color(0xFFFFA000) 
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFA000) : const Color(0xFFE0E0E0),
            width: 2,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!isAvailable)
              const Icon(Icons.close, color: Colors.grey, size: 20),
            Text(
              seats[index].label,
              style: TextStyle(
                color: !isAvailable 
                    ? Colors.grey 
                    : isSelected ? Colors.white : const Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem("Tersedia", Colors.white, border: true),
        _legendItem("Terisi", const Color(0xFFE0E0E0)),
        _legendItem("Dipilih", const Color(0xFFFFA000)),
      ],
    );
  }

  Widget _legendItem(String text, Color color, {bool border = false}) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: border ? Border.all(color: const Color(0xFFE0E0E0)) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildFooter() {
    int selectedCount = seats.where((s) => s.isSelected).length;
    double pricePerSeat = 150000;
    double totalPrice = selectedCount * pricePerSeat;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$selectedCount Kursi Terpilih",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  "Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                  style: const TextStyle(
                    color: Color(0xFF1A237E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: selectedCount > 0 ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    selectedSeats: selectedCount,
                    totalPrice: totalPrice,
                  ),
                ),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: const Color(0xFF1A237E),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: const Text(
              "Pesan Sekarang",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}