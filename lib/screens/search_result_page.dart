import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import 'package:intl/intl.dart';
import 'seat_selection_page.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class SearchResultPage extends StatefulWidget {
  final String originCity;
  final String destinationCity;
  final String date;

  const SearchResultPage({
    super.key,
    required this.originCity,
    required this.destinationCity,
    required this.date,
  });

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final List<BusSchedule> allSchedules = [
    BusSchedule(
      operatorName: "Madu Kismo",
      departureTime: "05:20",
      duration: "14j 10m",
      origin: "Bank Mandiri Mahendradata, Denpasar",
      destination: "Alfamart Nagrek, Bandung",
      price: 520000,
      availableSeats: 30,
      classType: "Executive",
      facilities: ["AC", "WiFi", "Toilet"],
    ),
    BusSchedule(
      operatorName: "Gunung Harta",
      departureTime: "07:00",
      duration: "15j 45m",
      origin: "Agen Cimahi Rani, Bandung",
      destination: "Terminal Mengwi, Denpasar",
      price: 603200,
      availableSeats: 12,
      classType: "Sleeper Class",
      facilities: ["AC", "WiFi", "Toilet", "Makan"],
    ),
    BusSchedule(
      operatorName: "Rosalia Indah",
      departureTime: "19:30",
      duration: "12j 30m",
      origin: "Terminal Terpadu Pulo Gebang",
      destination: "Terminal Tirtonadi, Solo",
      price: 450000,
      availableSeats: 8,
      classType: "Super Executive",
      facilities: ["AC", "WiFi", "Toilet", "Makan"],
    ),
    BusSchedule(
      operatorName: "Sinar Jaya",
      departureTime: "21:00",
      duration: "10j 15m",
      origin: "Terminal Lebak Bulus",
      destination: "Terminal Giwangan, Yogyakarta",
      price: 380000,
      availableSeats: 25,
      classType: "Suite Class",
      facilities: ["AC", "WiFi", "Toilet"],
    ),
  ];

  List<String> selectedTimes = [];
  List<String> selectedTypes = [];
  List<String> selectedFacilities = [];

  final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  List<BusSchedule> get filteredSchedules {
    return allSchedules.where((bus) {
      // Filter by Time
      bool matchesTime = true;
      if (selectedTimes.isNotEmpty) {
        int hour = int.parse(bus.departureTime.split(":")[0]);
        matchesTime = false;
        if (selectedTimes.contains("Pagi (00:00 - 12:00)") && hour < 12) matchesTime = true;
        if (selectedTimes.contains("Siang (12:00 - 18:00)") && hour >= 12 && hour < 18) matchesTime = true;
        if (selectedTimes.contains("Malam (18:00 - 24:00)") && hour >= 18) matchesTime = true;
      }

      // Filter by Type
      bool matchesType = true;
      if (selectedTypes.isNotEmpty) {
        matchesType = selectedTypes.contains(bus.classType);
      }

      // Filter by Facilities
      bool matchesFacilities = true;
      if (selectedFacilities.isNotEmpty) {
        matchesFacilities = selectedFacilities.every((f) => bus.facilities.contains(f));
      }

      return matchesTime && matchesType && matchesFacilities;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "${widget.originCity} ➔ ${widget.destinationCity}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.date} • ${filteredSchedules.length} Bus Tersedia",
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
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
        duration: const Duration(milliseconds: 1000),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSidebar(),
            Expanded(
              child: filteredSchedules.isEmpty 
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredSchedules.length,
                    itemBuilder: (context, index) => _buildBusCard(filteredSchedules[index], context),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 20),
          const Text("Tidak ada bus yang sesuai filter", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                selectedTimes.clear();
                selectedTypes.clear();
                selectedFacilities.clear();
              });
            },
            child: const Text("Reset Filter", style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSidebar() {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 24, top: 24, bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.tune_rounded, color: Color(0xFF1A237E)),
                SizedBox(width: 10),
                Text("Filter Pencarian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A237E))),
              ],
            ),
            const Divider(height: 40),
            _filterSection("Waktu Keberangkatan", ["Pagi (00:00 - 12:00)", "Siang (12:00 - 18:00)", "Malam (18:00 - 24:00)"], selectedTimes),
            const SizedBox(height: 20),
            _filterSection("Tipe Bus", ["Executive", "Sleeper Class", "Super Executive", "Suite Class"], selectedTypes),
            const SizedBox(height: 20),
            _filterSection("Fasilitas", ["AC", "WiFi", "Toilet", "Makan"], selectedFacilities),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedTimes.clear();
                    selectedTypes.clear();
                    selectedFacilities.clear();
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1A237E)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Reset Filter", style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterSection(String title, List<String> options, List<String> selectedList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 10),
        ...options.map((opt) {
          bool isSelected = selectedList.contains(opt);
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedList.remove(opt);
                  } else {
                    selectedList.add(opt);
                  }
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: isSelected, 
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedList.add(opt);
                          } else {
                            selectedList.remove(opt);
                          }
                        });
                      },
                      activeColor: const Color(0xFF1A237E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(opt, style: TextStyle(fontSize: 13, color: isSelected ? const Color(0xFF1A237E) : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBusCard(BusSchedule bus, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bus.operatorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1A237E))),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(10)),
                      child: Text(bus.classType, style: const TextStyle(color: Colors.brown, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1, indent: 20, endIndent: 20, color: Color(0xFFEEEEEE)),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _timeCol(bus.departureTime, "Berangkat"),
                        Column(
                          children: [
                            Text(bus.duration, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle)),
                                Container(width: 60, height: 1, color: const Color(0xFF1A237E)),
                                const Icon(Icons.directions_bus, size: 16, color: Color(0xFF1A237E)),
                                Container(width: 60, height: 1, color: const Color(0xFF1A237E)),
                                Container(width: 8, height: 8, decoration: BoxDecoration(border: Border.all(color: const Color(0xFF1A237E)), shape: BoxShape.circle)),
                              ],
                            ),
                          ],
                        ),
                        _timeCol(_calculateArrivalTime(bus.departureTime, bus.duration), "Tujuan", alignment: CrossAxisAlignment.end),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(bus.origin, style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 20),
                        Expanded(child: Text(bus.destination, textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1, indent: 20, endIndent: 20, color: Color(0xFFEEEEEE)),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currencyFormatter.format(bus.price), 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF1A237E))),
                    Text("${bus.availableSeats} kursi tersedia", style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatSelectionPage(
                                originCity: widget.originCity,
                                destinationCity: widget.destinationCity,
                                date: widget.date,
                                busName: "${bus.operatorName} - ${bus.classType}",
                                price: bus.price.toDouble(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("Pilih", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeCol(String time, String label, {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
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

  String _calculateArrivalTime(String departureTime, String duration) {
    try {
      final depParts = departureTime.split(":");
      final int depH = int.parse(depParts[0]);
      final int depM = int.parse(depParts[1]);

      int durH = 0;
      int durM = 0;
      final durParts = duration.split(" ");
      for (var p in durParts) {
        if (p.endsWith("j")) durH = int.parse(p.substring(0, p.length - 1));
        if (p.endsWith("m")) durM = int.parse(p.substring(0, p.length - 1));
      }

      int totalM = depM + durM;
      int extraH = totalM ~/ 60;
      int arrM = totalM % 60;
      int arrH = (depH + durH + extraH) % 24;

      return "${arrH.toString().padLeft(2, '0')}:${arrM.toString().padLeft(2, '0')}";
    } catch (e) {
      return "00:00";
    }
  }
}
