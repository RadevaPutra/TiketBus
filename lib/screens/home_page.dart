import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_result_page.dart';
import 'login_page.dart';
import 'travel_tips_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime departureDate = DateTime.now();
  DateTime? returnDate;
  String originCity = "Jakarta";
  String destinationCity = "Bandung";
  String selectedBus = "Rosalia Indah - Executive";

  final List<String> indonesianCities = [
    "Jakarta", "Bandung", "Surabaya", "Semarang", "Yogyakarta",
    "Solo", "Malang", "Denpasar", "Medan", "Palembang",
    "Makassar", "Balikpapan", "Pontianak", "Banjarmasin", "Manado",
    "Lampung", "Padang", "Pekanbaru", "Batam", "Bogor",
    "Tangerang", "Bekasi", "Depok", "Cirebon", "Tasikmalaya",
    "Sukabumi", "Purwokerto", "Magelang", "Kediri", "Madiun",
    "Probolinggo", "Pasuruan", "Mojokerto", "Banyuwangi", "Jember"
  ];

  final List<String> busOperators = [
    "Rosalia Indah - Executive",
    "Rosalia Indah - Sleeper",
    "Sinar Jaya - Executive",
    "Sinar Jaya - Suite Class",
    "PO Haryanto - Executive",
    "PO Haryanto - VIP",
    "Gunung Harta - Solutions",
    "Pahala Kencana - Business",
    "Lorena - Executive",
    "Kramat Djati - VIP",
    "Harapan Jaya - Super Luxury",
    "Agra Mas - Executive",
    "Bejeu - VIP",
    "Sudiro Tungga Jaya - Executive"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: _buildGlassNavbar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildModernHeroSection(),
            _buildPremiumInfoSection(),
            _buildPromoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassNavbar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bus, color: Colors.amber, size: 30),
          const SizedBox(width: 10),
          const Text(
            "BUSONLINE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5),
          ),
          const Spacer(),
          _navItem("Beranda", isActive: true, onTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
          }),
          _navItem("Tiket Bus", onTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
          }),
          _navItem("Tips Perjalanan", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TravelTipsPage()));
          }),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Masuk / Daftar", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title, {bool isActive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.amber : Colors.white70,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeroSection() {
    return Container(
      height: 700,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=2069'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bepergian dengan Nyaman",
              style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 4),
            ),
            const SizedBox(height: 10),
            const Text(
              "Jelajahi Indonesia Bersama Kami",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            _buildFloatingSearchContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingSearchContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 15)),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _locationItem("Asal", originCity, Icons.location_on_rounded, (city) {
            setState(() => originCity = city);
          })),
          _divider(),
          Expanded(child: _locationItem("Tujuan", destinationCity, Icons.location_city_rounded, (city) {
            setState(() => destinationCity = city);
          })),
          _divider(),
          Expanded(child: _busSelectionItem("Bus & Kelas", selectedBus, Icons.directions_bus_filled_rounded, (bus) {
            setState(() => selectedBus = bus);
          })),
          _divider(),
          Expanded(child: _dateItem("Pergi", departureDate)),
          const SizedBox(width: 20),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1.5, height: 50, color: Colors.grey.withOpacity(0.2), margin: const EdgeInsets.symmetric(horizontal: 10));
  }

  Widget _locationItem(String label, String value, IconData icon, Function(String) onSelected) {
    return InkWell(
      onTap: () => _showLocationPicker(label, value, onSelected),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1A237E), size: 16),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _busSelectionItem(String label, String value, IconData icon, Function(String) onSelected) {
    return InkWell(
      onTap: () => _showBusPicker(label, value, onSelected),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1A237E), size: 16),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(String label, String currentValue, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Pilih Kota $label", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: indonesianCities.length,
                itemBuilder: (context, index) {
                  String city = indonesianCities[index];
                  bool isSelected = city == currentValue;
                  return ListTile(
                    leading: Icon(Icons.location_on_rounded, color: isSelected ? Colors.amber : Colors.grey),
                    title: Text(city, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF1A237E) : Colors.black87)),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF1A237E)) : null,
                    onTap: () {
                      onSelected(city);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBusPicker(String label, String currentValue, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: const Text("Pilih Operator & Kelas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: busOperators.length,
                itemBuilder: (context, index) {
                  String bus = busOperators[index];
                  bool isSelected = bus == currentValue;
                  return ListTile(
                    leading: Icon(Icons.directions_bus_filled_rounded, color: isSelected ? Colors.amber : Colors.grey),
                    title: Text(bus, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF1A237E) : Colors.black87)),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF1A237E)) : null,
                    onTap: () {
                      onSelected(bus);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateItem(String label, DateTime? date, {bool isOptional = false}) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2027),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(primary: Color(0xFF1A237E)),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            if (label == "Pergi") departureDate = picked; else returnDate = picked;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: Color(0xFF1A237E), size: 16),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date != null ? DateFormat('dd MMM yyyy').format(date) : (isOptional ? "Opsional" : "Pilih Tanggal"),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(
              originCity: originCity,
              destinationCity: destinationCity,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A237E),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
      child: const Row(
        children: [
          Text("Cari Perjalanan", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildPremiumInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 50),
      color: const Color(0xFFF8F9FB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _premiumInfoItem(Icons.verified_user_rounded, "Keamanan Terjamin", "Transaksi aman & terpercaya"),
          _premiumInfoItem(Icons.local_offer_rounded, "Harga Terbaik", "Diskon eksklusif setiap hari"),
          _premiumInfoItem(Icons.support_agent_rounded, "Bantuan 24/7", "Layanan pelanggan profesional"),
        ],
      ),
    );
  }

  Widget _premiumInfoItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
          ),
          child: Icon(icon, color: const Color(0xFF1A237E), size: 35),
        ),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Promosi Spesial", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          const SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _promoCard("Liburan Hemat", "Diskon hingga 30%", "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=600"),
                const SizedBox(width: 20),
                _promoCard("Cashback Ceria", "Dapatkan poin ekstra", "https://images.unsplash.com/photo-1554224155-169641357599?auto=format&fit=crop&q=80&w=600"),
                const SizedBox(width: 20),
                _promoCard("Voucher Bus", "Potongan Rp 50.000", "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=600"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
