import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_result_page.dart';
import 'login_page.dart';
import 'travel_tips_page.dart';
import '../services/auth_service.dart';
import 'bus_tracking_page.dart';
import 'admin_fleet_page.dart';
import 'profile_page.dart';
import 'my_orders_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime departureDate = DateTime.now();
  DateTime? returnDate;
  String? originCity;
  String? destinationCity;
  
  final ScrollController _scrollController = ScrollController();

  final List<String> indonesianCities = [
    "Jakarta", "Bandung", "Surabaya", "Semarang", "Yogyakarta",
    "Solo", "Malang", "Denpasar", "Medan", "Palembang",
    "Makassar", "Balikpapan", "Pontianak", "Banjarmasin", "Manado",
    "Lampung", "Padang", "Pekanbaru", "Batam", "Bogor",
    "Tangerang", "Bekasi", "Depok", "Cirebon", "Tasikmalaya",
    "Sukabumi", "Purwokerto", "Magelang", "Kediri", "Madiun",
    "Probolinggo", "Pasuruan", "Mojokerto", "Banyuwangi", "Jember"
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: _buildGlassNavbar(),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1200),
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
          controller: _scrollController,
          child: Column(
            children: [
              _buildModernHeroSection(),
              _buildPremiumInfoSection(),
              _buildPromoSection(),
              _buildTouristDestinationsSection(),
              const SizedBox(height: 50),
            ],
          ),
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
          const _AnimatedBusLogo(),
          const SizedBox(width: 10),
          const Text(
            "SmartBus",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5),
          ),
          const Spacer(),
          _navItem("Beranda", isActive: true, onTap: () {
            _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          }),
          _navItem("Promo", onTap: () {
            _scrollController.animateTo(860.0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
          }),
          _navItem("Pesanan Saya", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage()));
          }),
          _navItem("Tips Perjalanan", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TravelTipsPage()));
          }),
          const SizedBox(width: 20),
          AuthService().isLoggedIn
              ? _buildUserMenu()
              : ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    if (result == true) {
                      setState(() {}); // Rebuild to show user icon
                    }
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

  Widget _buildUserMenu() {
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
        PopupMenuItem<String>(
          value: 'track',
          onTap: () {
            final activeBookings = AuthService().activeBookings;
            if (activeBookings.isNotEmpty) {
              final latest = activeBookings.last;
              Navigator.push(context, MaterialPageRoute(builder: (context) => BusTrackingPage(
                busName: latest.busName,
                bookingId: latest.id,
                origin: latest.origin,
                destination: latest.destination,
              )));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BusTrackingPage(
                busName: "Bus Dummy",
                bookingId: "BK-000000",
                origin: "Origin Dummy",
                destination: "Dest Dummy",
              )));
            }
          },
          child: const Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.indigo),
              SizedBox(width: 10),
              Text("Lacak Perjalanan"),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'profile',
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            });
          },
          child: const Row(
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
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.amber, width: 2),
        ),
        child: const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.indigo,
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
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

  Widget _locationItem(String label, String? value, IconData icon, Function(String) onSelected) {
    bool hasValue = value != null && value.isNotEmpty;
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
            hasValue ? value : "Pilih Kota $label",
            style: TextStyle(
              fontSize: 14,
              fontWeight: hasValue ? FontWeight.bold : FontWeight.normal,
              color: hasValue ? Colors.black87 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(String label, String? currentValue, Function(String) onSelected) {
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
        if (originCity == null || destinationCity == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pilih rute asal dan tujuan terlebih dahulu!"),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(
              originCity: originCity!,
              destinationCity: destinationCity!,
              date: DateFormat('dd MMM yyyy').format(departureDate),
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
                _promoCard("Liburan Hemat", "Diskon hingga 30%", "Kode: HEMAT30", "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=600"),
                const SizedBox(width: 20),
                _promoCard("Cashback Ceria", "Dapatkan poin ekstra", "Tanpa Kode", "https://images.unsplash.com/photo-1554224155-169641357599?auto=format&fit=crop&q=80&w=600"),
                const SizedBox(width: 20),
                _promoCard("Voucher Bus", "Potongan Rp 50.000", "Kode: DISKON50K", "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=600"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCard(String title, String subtitle, String code, String imageUrl) {
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
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Text(
                code,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTouristDestinationsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Destinasi Wisata Terindah & Rute Terbaik di Indonesia", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          const SizedBox(height: 10),
          const Text(
            "Temukan pesona alam dan budaya nusantara dari kenyamanan perjalanan bus Anda. Kami merekomendasikan destinasi terbaik di berbagai pulau beserta informasinya.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          _destinationCard(
            "Pulau Bali: Surga Dewata",
            "Wisata Pilihan:",
            "• Pantai Kuta & Seminyak: Nikmati sunset memukau dan pasir putih membentang.\n• Ubud: Rasakan keheningan dengan pemandangan terasering sawah Tegalalang yang asri.\n• Pura Uluwatu: Pura di atas tebing karang dengan tarian kecak berlatar senja.\n• Gunung Batur: Pemandangan kaldera dan danau yang sangat indah dari rute pegunungan.\nPerjalanan bus menuju Bali menjadi sangat berkesan ketika Anda melewati rute pantura dan menyeberang menggunakan feri melintasi Selat Bali yang eksotis. Pilih rute malam hari untuk menikmati semilir angin laut.",
            "https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80&w=800",
          ),
          const SizedBox(height: 30),
          _destinationCard(
            "Pulau Jawa: Jejak Budaya & Alam",
            "Wisata Pilihan:",
            "• Gunung Bromo (Jawa Timur): Perjalanan mendebarkan melihat lautan pasir dan sunrise yang magis.\n• Candi Borobudur (Magelang/Jawa Tengah): Candi Budha terbesar di dunia dengan susunan batuan yang menakjubkan.\n• Kawah Putih ciwidey (Bandung/Jawa Barat): Danau belerang putih dengan nuansa alam berkabut.\n• Pantai Selatan (Yogyakarta): Pemandangan pantai yang sangat indah dari rute jalanan pesisir seperti Pantai Parangtritis.\nRute Tol Trans-Jawa saat ini sangat mulus dan cepat, sambil menawarkan lanskap persawahan, perbukitan, serta gunung-gunung gagah sebagai latar belakang.",
            "https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&q=80&w=800",
            isReversed: true,
          ),
          const SizedBox(height: 30),
          _destinationCard(
            "Pulau Sumatera: Alam Liar & Danau Indah",
            "Wisata Pilihan:",
            "• Danau Toba & Pulau Samosir (Sumatera Utara): Danau vulkanik terbesar dengan kebudayaan Batak yang kental.\n• Jam Gadang & Ngarai Sianok (Sumatera Barat): Pemandangan lembang hijau yang menawan di Bukittinggi.\n• Pantai Lhoknga & Lampuuk (Aceh): Pesona pasir putih di ujung barat Indonesia.\n• Gunung Kerinci (Jambi): Lanskap indah untuk para pecinta alam.\nPerjalanan Lintas Sumatera sangat populer karena rute ini menembus hutan tropis, perbukitan, hingga kawasan Kelok 9 yang merupakan salah satu karya infrastruktur paling ikonik yang menyatu dengan tebing alaminya.",
            "https://images.unsplash.com/photo-1596422846543-7ec94c1c9ff5?auto=format&fit=crop&q=80&w=800",
          ),
          const SizedBox(height: 30),
          _destinationCard(
            "Pulau Kalimantan: Eksotisme Hutan Tropis",
            "Wisata Pilihan:",
            "• Pasar Terapung Lok Baintan (Banjarmasin): Merasakan sensasi jual-beli di atas perahu.\n• Kepulauan Derawan (Kaltim): Spot diving terbaik dengan keanekaragaman biota laut.\n• Taman Nasional Tanjung Puting (Kalteng): Melihat orangutan di habitat aslinya.\nEksplorasi Kalimantan dengan rute bus memberi pengalaman menyusuri sungai-sungai besar dan rute trans-Kalimantan yang membelah rimbunnya hutan tropis.",
            "https://images.unsplash.com/photo-1604928141064-207cea6f5722?auto=format&fit=crop&q=80&w=800",
            isReversed: true,
          ),
        ],
      ),
    );
  }

  Widget _destinationCard(String title, String subtitle, String description, String imageUrl, {bool isReversed = false}) {
    List<Widget> content = [
      Expanded(
        flex: 2,
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 40),
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              ),
              child: const Text("Cari Tiket Ke Sini", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isReversed ? content.reversed.toList() : content,
      ),
    );
  }
}

class _AnimatedBusLogo extends StatefulWidget {
  const _AnimatedBusLogo();

  @override
  _AnimatedBusLogoState createState() => _AnimatedBusLogoState();
}

class _AnimatedBusLogoState extends State<_AnimatedBusLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: const Offset(0, 0.15),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: const Icon(Icons.directions_bus, color: Colors.amber, size: 30),
    );
  }
}
