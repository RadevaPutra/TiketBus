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
                    "Tempat Wisata Terindah di Indonesia",
                    "Eksplorasi destinasi memukau dari Bali, Jawa, Sumatera, hingga pulau lainnya.",
                    "https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80&w=600",
                    "Indonesia adalah kepulauan eksotis yang keindahan alam dan budayanya telah memukau jutaan pelancong dari seluruh dunia. Bagi Anda yang ingin merencanakan liburan luar biasa dengan menggunakan perjalanan darat atau bus, berikut adalah panduan lengkap destinasi wisata terindah di berbagai pulau utama di nusantara:\n\n"
                    "1. Pulau Bali: Sang Primadona Destinasi Dunia (Pulau Dewata)\n"
                    "Bali selalu menjadi magnet utama pariwisata. Jika Anda menyukai suasana tenang dan spiritual, Ubud adalah pilihan yang tepat dengan panorama Terasering Sawah Tegalalang (Tegalalang Rice Terrace) dan Monkey Forest yang sakral. Untuk penikmat senja, Pura Uluwatu menyuguhkan pertunjukan Tari Kecak yang epik tepat di atas tebing karang setinggi 70 meter yang berhadapan langsung dengan deburan ombak Samudra Hindia. Tak terlupa, deretan pantai legendaris seperti Pantai Seminyak, Kuta, hingga Pantai Pandawa senantiasa menyajikan pasir putih bersih. Perjalanan naik bus dari Jawa menuju Bali memberikan pengalaman unik karena Anda akan menyeberang menggunakan Kapal Feri di Selat Bali pagi hari sambil menikmati matahari terbit dan hembusan angin laut.\n\n"
                    "2. Pulau Jawa: Paduan Sempurna Alam Liar & Peradaban Masa Lalu\n"
                    "Jawa menyimpan kemuliaan sejarah dunia melalui Candi Borobudur di Magelang, candi Buddha terbesar di dunia yang dikelilingi hutan dan perbukitan menawan; serta Candi Prambanan di Yogyakarta sebagai lambang romansa mitologi kuno. Bagi pecinta alam liar, Gunung Bromo di Jawa Timur menawarkan pemandangan lautan pasir berbisik, kawah aktif, dan pemandangan rona matahari terbit (sunrise) yang tak ada duanya dari Kawah Penanjakan. Bergeser ke Jawa Barat, terdapat Kawah Putih Ciwidey di Bandung yang menghadirkan nuansa magis berupa danau kawah vulkanik berwarna putih kehijauan yang kerap diselimuti kabut tebal. Rute darat di Pulau Jawa kini semakin memanjakan mata dengan Jalan Tol Trans-Jawa yang menyuguhkan lanskap persawahan, perbukitan karst, serta gunung-gunung menjulang di sepanjang jalan.\n\n"
                    "3. Pulau Sumatera: Petualangan Jalur Lintas & Hutan Eksotis\n"
                    "Perjalanan bus Anda di jantung Sumatera akan menembus lebatnya hutan tropis hujan yang asri dan membelah rute legendaris Pegunungan Bukit Barisan. Di Sumatera Utara, terbentang maha karya alam Danau Toba, danau vulkanik terdalam di dunia dengan keunikan Pulau Samosir di tengahnya yang memiliki pusaka budaya Batak Toba yang sangat kental. Melaju ke Sumatera Barat, Anda akan disambut oleh liukan ekstrem nan indah Kelok 9 sebelum tiba di ikon Jam Gadang Bukittinggi untuk kemudian bersantai menikmati pemandangan Ngarai Sianok yang menghijau layaknya lembah dari negeri dongeng. Sementara di ujung paling utara, provinsi Aceh menyimpan Pantai Lhoknga dan Pulau Weh (Sabang) dengan pesona terumbu karang kelas dunia.\n\n"
                    "4. Kepulauan Nusa Tenggara: Lanskap Prasejarah & Savana Membentang\n"
                    "Melintasi Bali lebih jauh jangkauannya menuju wilayah kepulauan Nusa Tenggara, Anda akan menemukan keajaiban di Pulau Komodo dan Rinca. Saksikan langsung kehebatan reptil purba legendaris, Komodo, pada habitat asli sabananya yang langka. Kepulauan ini juga memiliki Pulau Padar dengan lanskap epik tiga lekukan teluk yang sangat khas. Lebih jauh mengarah ke bagian timur nusantara, Pulau Sumba menawarkan pesona perbukitan Wairinding yang membentang bak karpet alam raksasa, sementara pulau Flores memancarkan daya pikat utamanya lewat Danau Kelimutu, danau vulkanik yang airnya mampu mengubah warnanya seiring siklus alam.\n\n"
                    "5. Pulau Sulawesi: Surga Terumbu Karang dan Budaya Lintas Batas\n"
                    "Bentuk unik layaknya huruf 'K' membawa Sulawesi mengoleksi segudang wisata tiada tanding. Di utara, Taman Nasional Bunaken di Manado mendominasi eksistensinya sebagai salah satu spot diving serta snorkeling termegah di Asia. Turun ke wilayah bagian Selatan, terdapat Tana Toraja yang menawarkan upacara kebudayaan dan rumah adat Tongkonan di desa-desa yang diselimuti awan pegunungan tinggi; disempurnakan lagi dengan Pantai Bira di pelosok Makassar yang masyhur merajai pantai berpasir sehalus tepung.",
                  ),
                  const SizedBox(height: 20),
                  _buildArticleCard(
                    context,
                    "Cara Tidur Nyaman di Bus Malam",
                    "Tips memilih posisi duduk dan perlengkapan tidur yang wajib dibawa.",
                    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=600",
                    "Tidur nyaman di bus malam adalah kunci agar Anda sampai di tujuan dengan keadaan bugar, otot tidak pegal, dan siap langsung beraktivitas secara optimal keesokan harinya. Seringkali, tidur di kendaraan bergerak apalagi dengan goncangan dan suhu AC yang dingin dapat menjadi tantangan tersendiri bagi sebagian penumpang. Oleh karena itu, persiapan menyeluruh merupakan fondasi utama perjalanan yang menyenangkan.\n\n"
                    "1. Persiapan Pakaian & Perlengkapan Anti-Kedinginan\n"
                    "Pastikan Anda mengenakan pakaian berlapis (layering) seperti kaos katun yang menyerap keringat dipadukan dengan sweater atau jaket berbahan tebal namun lembut. Sebaiknya hindari celana berbahan kaku seperti jeans ketat, dan beralihlah ke celana training atau jogger berbahan longgar. Jangan lupa kenakan kaos kaki tebal untuk mencegah masuk angin dari telapak kaki, mengingat suhu AC di dalam kabin bus malam seringkali sangat rendah/dingin di sepanjang rute.\n\n"
                    "2. Perlengkapan Tidur Esensial (Travel Sleep-Kit)\n"
                    "Bawalah 'travel sleep-kit' pribadi Anda: sebuah bantal leher (neck pillow) berbahan memory foam atau U-shape yang dapat menopang leher 360 derajat agar kepala tidak terayun-ayun saat bus berguncang. Selain itu, sepasang penyumbat telinga (earplugs) berukuran pas atau earphone dengan fitur noise-canceling akan sangat membantu memblokir suara dengkuran penumpang lain, suara mesin bus, serta klakson di jalan raya. Penutup mata (eye mask) juga krusial untuk menciptakan suasana gelap gulita yang menstimulasi produksi hormon melatonin, sehingga Anda bisa cepat terlelap meskipun ada terang dari lampu jalan atau kendaraan lain.\n\n"
                    "3. Manajemen Posisi Duduk & Postur\n"
                    "Sesuaikan kemiringan kursi (reclining seat) pada sudut yang paling rileks (biasanya 130-140 derajat) dan pastikan untuk meminta izin terlebih dahulu kepada penumpang di belakang Anda. Gunakan sandaran kaki (leg rest) jika bus menyediakannya, atau luruskan kaki sejauh mungkin guna melancarkan sirkulasi darah serta menghindari pembengkakan (deep vein thrombosis). Anda bisa menggulung jaket atau selimut sekunder untuk diletakkan di pangkal punggung (lumbar support) agar tulang belakang tetap terjaga kelurusannya dan terhindar dari rasa nyeri pinggang saat bangun.\n\n"
                    "4. Mengatur Pola Makan & Minum Sebelum Berangkat\n"
                    "Hindari mengonsumsi makanan berat yang memicu gas (seperti kubis, kacang-kacangan) atau makanan bersantan dan pedas yang dapat menyebabkan gangguan pencernaan saat bus melaju di jalan berkelok. Jauhi konsumsi kafein berlebih setidaknya enam jam sebelum naik bus, serta kurangi asupan air putih atau minuman manis yang berlebihan mendekati jam tidur agar Anda tidak perlu bolak-balik terbangun untuk pergi ke toilet bus. Minumlah secukupnya (misal, air hangat atau teh chamomile dalam porsi kecil) agar tenggorokan tetap lembab.\n\n"
                    "5. Menjaga Keamanan Barang Berharga Selama Terlelap\n"
                    "Perasaan was-was adalah musuh utama tidur nyenyak. Untuk itu, amankan barang berharga (smartphone, dompet, KTP, dsb) di dalam tas selempang kecil (body bag) yang Anda kenakan dan sembunyikan di balik jaket. Jika membawa ransel kecil, peluklah ransel tersebut atau selipkan tali tas pada kaki Anda atau lengan kursi, sehingga Anda akan langsung terbangun jika terjadi pergerakan tas yang tidak diinginkan. Dengan barang yang aman, pikiran akan rileks dan tidur nyenyak pun bisa didapatkan meskipun di jalan tol maupun rute bergelombang.",
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
