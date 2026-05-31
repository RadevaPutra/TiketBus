import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminFleetPage extends StatefulWidget {
  const AdminFleetPage({super.key});

  @override
  State<AdminFleetPage> createState() => _AdminFleetPageState();
}

class _AdminFleetPageState extends State<AdminFleetPage> {
  late GoogleMapController _mapController;

  final List<Map<String, dynamic>> _fleet = [
    {
      "id": "BUS-001",
      "name": "Rosalia Indah - Executive",
      "status": "Beroperasi",
      "location": const LatLng(-6.2088, 106.8456),
      "driver": "Budi Santoso",
      "speed": "65 km/h",
      "route": "Jakarta -> Solo",
      "onTime": true,
    },
    {
      "id": "BUS-002",
      "name": "Sinar Jaya - Suite Class",
      "status": "Beroperasi",
      "location": const LatLng(-6.9175, 107.6191),
      "driver": "Agus Salim",
      "speed": "72 km/h",
      "route": "Bandung -> Surabaya",
      "onTime": false,
    },
    {
      "id": "BUS-003",
      "name": "PO Haryanto - VIP",
      "status": "Istirahat",
      "location": const LatLng(-7.0051, 110.4381),
      "driver": "Eko Prasetyo",
      "speed": "0 km/h",
      "route": "Semarang -> Jakarta",
      "onTime": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fleet Monitoring Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded)),
        ],
      ),
      body: Row(
        children: [
          // Sidebar - Fleet List
          _buildFleetSidebar(),
          
          // Main Content - Global Map
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-6.5, 108), // Central View
                    zoom: 7,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _fleet.map((bus) => Marker(
                    markerId: MarkerId(bus['id']),
                    position: bus['location'],
                    infoWindow: InfoWindow(title: bus['name'], snippet: "Driver: ${bus['driver']}"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      bus['status'] == 'Beroperasi' ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueRed
                    ),
                  )).toSet(),
                ),
                
                // Analytics Overlay
                _buildAnalyticsOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFleetSidebar() {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari unit atau sopir...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _fleet.length,
              itemBuilder: (context, index) {
                final bus = _fleet[index];
                return _buildBusListItem(bus);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusListItem(Map<String, dynamic> bus) {
    return InkWell(
      onTap: () {
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(bus['location'], 12));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(bus['id'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 12)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: bus['onTime'] ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    bus['onTime'] ? "ON TIME" : "DELAY",
                    style: TextStyle(color: bus['onTime'] ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(bus['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(bus['driver'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.speed, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(bus['speed'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.map_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(bus['route'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsOverlay() {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ringkasan Operasional", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 15),
            _analyticRow("Total Armada", "14 Unit", Colors.indigo),
            _analyticRow("Aktif Beroperasi", "8 Unit", Colors.green),
            _analyticRow("Terlambat (Delay)", "2 Unit", Colors.red),
            _analyticRow("Butuh Perawatan", "1 Unit", Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _analyticRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 20),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
