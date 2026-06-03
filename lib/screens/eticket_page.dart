import 'package:flutter/material.dart';

class ETicketPage extends StatelessWidget {
  final String bookingId;
  final String busName;
  final String route;
  final String date;
  final String seats;

  const ETicketPage({
    super.key,
    required this.bookingId,
    required this.busName,
    required this.route,
    required this.date,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    List<String> routeParts = route.split(' - ');
    String origin = routeParts.isNotEmpty ? routeParts.first : 'Asal';
    String destination = routeParts.length > 1 ? routeParts.last : 'Tujuan';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Soft premium background
      appBar: AppBar(
        title: const Text("Boarding Pass", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 40, offset: const Offset(0, 20)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Label Premium
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.directions_bus_rounded, color: Colors.amber, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("SMARTBUS", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
                              Text("ID: $bookingId", style: const TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 1)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("ASAL", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(origin, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                const Icon(Icons.arrow_forward_rounded, color: Colors.amber),
                                const SizedBox(height: 5),
                                const Icon(Icons.circle, color: Colors.white38, size: 8),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("TUJUAN", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(destination, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Cutout effect blending & body
                Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildInfoDetail("Status Tiket", "LUNAS")),
                                Expanded(child: _buildInfoDetail("Operator Bus", busName, isRight: true)),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildInfoDetail("Tanggal Berangkat", date)),
                                Expanded(child: _buildInfoDetail("Nomor Kursi", seats, isRight: true)),
                              ],
                            ),
                            const SizedBox(height: 35),
                            const _DottedDivider(),
                            const SizedBox(height: 35),
                            const Text("Tunjukkan QR Code ini kepada petugas", style: TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade200, width: 2),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                              ),
                              child: const Icon(Icons.qr_code_2_rounded, size: 140, color: Color(0xFF1A237E)),
                            ),
                            const SizedBox(height: 15),
                            Text(bookingId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 3, color: Color(0xFF1A237E))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoDetail(String label, String value, {bool isRight = false}) {
    return Column(
      crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold), textAlign: isRight ? TextAlign.right : TextAlign.left),
      ],
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        const dashHeight = 2.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),
            );
          }),
        );
      },
    );
  }
}
