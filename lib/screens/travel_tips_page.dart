import 'package:flutter/material.dart';
import 'article_detail_page.dart';

class TravelTipsPage extends StatelessWidget {
  const TravelTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tips Perjalanan", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Panduan Perjalanan Bus",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Pastikan perjalanan Anda aman dan nyaman dengan tips berikut ini.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  _buildTipCard(
                    "Pesan Tiket Lebih Awal",
                    "Dapatkan harga terbaik dan kursi favorit dengan memesan tiket minimal 3 hari sebelum keberangkatan.",
                    Icons.event_available_rounded,
                    Colors.blue.shade100,
                  ),
                  _buildTipCard(
                    "Siapkan Dokumen Penting",
                    "Jangan lupa membawa KTP atau SIM asli sebagai syarat boarding di terminal bus.",
                    Icons.assignment_ind_rounded,
                    Colors.orange.shade100,
                  ),
                  _buildTipCard(
                    "Datang Tepat Waktu",
                    "Usahakan tiba di terminal 30 menit sebelum jadwal keberangkatan untuk proses check-in.",
                    Icons.access_time_filled_rounded,
                    Colors.green.shade100,
                  ),
                  _buildTipCard(
                    "Jaga Barang Bawaan",
                    "Pastikan barang berharga selalu berada dalam jangkauan Anda atau gunakan label pengenal pada bagasi.",
                    Icons.luggage_rounded,
                    Colors.purple.shade100,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Artikel Populer",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 20),
                  _buildArticleCard(
                    context,
                    "5 Rute Bus Terindah di Pulau Jawa",
                    "Nikmati pemandangan gunung dan pantai dari jendela bus Anda.",
                    "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=600",
                    "Pulau Jawa memiliki berbagai rute bus dengan pemandangan yang menakjubkan. Beberapa di antaranya meliputi rute selatan Jawa yang menawarkan pemandangan pantai selatan yang eksotis, serta rute pegunungan yang melalui daerah Puncak atau tol Trans-Jawa yang mulus dan cepat.\n\nPerjalanan menggunakan bus memberikan pengalaman berbeda, karena Anda bisa menikmati indahnya alam sepanjang perjalanan tanpa harus bingung menyetir sendiri. Jangan lupa pilih kursi dekat jendela untuk pengalaman visual yang optimal saat melewati perbukitan, desa-desa asri, atau pesisir yang membentang luas.",
                  ),
                  const SizedBox(height: 20),
                  _buildArticleCard(
                    context,
                    "Cara Tidur Nyaman di Bus Malam",
                    "Tips memilih posisi duduk dan perlengkapan tidur yang wajib dibawa.",
                    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=600",
                    "Tidur nyaman di bus malam adalah kunci agar Anda sampai di tujuan dengan keadaan segar. Pertama, pilihlah pakaian yang longgar dan cukup hangat. Bawa juga perlengkapan tidur seperti bantal leher U-shape, penutup mata, dan jaket tebal.\n\nUsahakan mengatur kursi (reclining) pada posisi yang paling pas tanpa mengganggu penumpang di belakang. Hindari terlalu banyak minum sebelum naik bus agar Anda tidak sering terbangun. Terakhir, tidurlah dengan posisi yang nyaman dan amankan barang berharga di dekat Anda.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline_rounded, color: Colors.amber, size: 50),
            SizedBox(height: 10),
            Text(
              "Inspirasi Perjalanan Anda",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon, Color bgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: const Color(0xFF1A237E), size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, String title, String subtitle, String imageUrl, String content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(
              title: title,
              imageUrl: imageUrl,
              content: content,
            ),
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              child: Image.network(imageUrl, width: 120, height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
