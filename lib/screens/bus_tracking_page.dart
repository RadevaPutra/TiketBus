import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
class BusTrackingPage extends StatefulWidget {
  final String busName;
  final String bookingId;
  final String origin;
  final String destination;

  const BusTrackingPage({
    super.key,
    required this.busName,
    required this.bookingId,
    this.origin = "Titik Penjemputan",
    this.destination = "Tujuan Akhir",
  });

  @override
  _BusTrackingPageState createState() => _BusTrackingPageState();
}

class _BusTrackingPageState extends State<BusTrackingPage> {
  late GoogleMapController mapController;
  BitmapDescriptor? busIcon;

  late LatLng _pickupLocation;
  late LatLng _dropoffLocation;
  late LatLng _busLocation;

  // Real Route Points from OSRM
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = true;

  // Kamus Koordinat Kota / Terminal
  final Map<String, LatLng> _locationCoordinates = {
    "bandung": const LatLng(-6.914744, 107.609810),
    "jakarta": const LatLng(-6.2088, 106.8456),
    "pulo gebang": const LatLng(-6.2088, 106.8456),
    "lebak bulus": const LatLng(-6.2891, 106.7745),
    "denpasar": const LatLng(-8.6500, 115.2167),
    "manado": const LatLng(1.481024, 124.846504),
    "surabaya": const LatLng(-7.2504, 112.7688),
    "yogyakarta": const LatLng(-7.7956, 110.3695),
  };

  LatLng _getCoordinatesFromString(String locationName) {
    String lowerName = locationName.toLowerCase();
    for (var entry in _locationCoordinates.entries) {
      if (lowerName.contains(entry.key)) {
        return entry.value;
      }
    }
    // Default fallback jika lokasi tidak dikenali
    return const LatLng(-6.2088, 106.8456); // Jakarta Default
  }

  @override
  void initState() {
    super.initState();
    _pickupLocation = _getCoordinatesFromString(widget.origin);
    _dropoffLocation = _getCoordinatesFromString(widget.destination);
    
    // Inisialisasi awal bus di titik jemput
    _busLocation = _pickupLocation;
    
    _loadCustomIcon();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    try {
      final double startLat = _pickupLocation.latitude;
      final double startLon = _pickupLocation.longitude;
      final double endLat = _dropoffLocation.latitude;
      final double endLon = _dropoffLocation.longitude;

      if (startLat == endLat && startLon == endLon) {
        // Fallback jika asal dan tujuan sama (menggeser sedikit dropoff nya biar bisa bikin garis)
        _dropoffLocation = LatLng(endLat + 0.05, endLon + 0.05);
      }

      final String url = 
          'http://router.project-osrm.org/route/v1/driving/$startLon,$startLat;$endLon,${_dropoffLocation.latitude}?geometries=geojson&overview=full';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final List coordinates = data['routes'][0]['geometry']['coordinates'];
          
          List<LatLng> points = coordinates.map((coord) {
            return LatLng(coord[1], coord[0]);
          }).toList();

          setState(() {
            _routePoints = points;
            // Tempatkan bus tepat di tengah-tengah perjalanan
            if (_routePoints.length > 2) {
              _busLocation = _routePoints[_routePoints.length ~/ 2];
            } else {
              _busLocation = _pickupLocation;
            }
            _isLoadingRoute = false;
          });

          // Mengatur posisi kamera map agar seluruh rute terlihat
          _adjustMapBounds();
          return;
        }
      }
    } catch (e) {
      debugPrint("Gagal mengambil rute: $e");
    }

    // FALLBACK jika gagal ambil rute OSRM
    setState(() {
      _routePoints = [
        _pickupLocation,
        LatLng((_pickupLocation.latitude + _dropoffLocation.latitude) / 2, 
               (_pickupLocation.longitude + _dropoffLocation.longitude) / 2),
        _dropoffLocation,
      ];
      _busLocation = _routePoints[1];
      _isLoadingRoute = false;
    });
    _adjustMapBounds();
  }

  void _adjustMapBounds() {
    if (_routePoints.isEmpty) return;

    double minLat = _routePoints.first.latitude;
    double minLon = _routePoints.first.longitude;
    double maxLat = _routePoints.first.latitude;
    double maxLon = _routePoints.first.longitude;

    for (var point in _routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLon) minLon = point.longitude;
      if (point.longitude > maxLon) maxLon = point.longitude;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLon),
            northeast: LatLng(maxLat, maxLon),
          ),
          50.0, // Padding
        ),
      );
    });
  }

  // Fungsi untuk memuat lambang mobil bus kustom
  Future<void> _loadCustomIcon() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    // Background lingkaran dengan warna tema
    final Paint paint = Paint()..color = const Color(0xFF1A237E); 
    canvas.drawCircle(const Offset(40, 40), 40, paint);

    // Menggambar icon bus
    const IconData iconData = Icons.directions_bus;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: 50.0,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(40 - textPainter.width / 2, 40 - textPainter.height / 2),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(80, 80);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final Uint8List uint8List = byteData.buffer.asUint8List();
      setState(() {
        busIcon = BitmapDescriptor.fromBytes(uint8List);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveBooking = AuthService().hasActiveBooking;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pelacakan Real-Time - Kelompok 3"),
        backgroundColor: const Color(0xFF8E0E00), // Sesuai warna Project Charter
        foregroundColor: Colors.white,
      ),
      body: hasActiveBooking 
        ? Stack(
            children: [
              _isLoadingRoute 
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                      _adjustMapBounds();
                    },
                    initialCameraPosition: CameraPosition(
                      target: _busLocation,
                      zoom: 6.0, // Zoom out default sebelum animasi bounds
                    ),
                    // Rute perjalanan nyara
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: _routePoints,
                        color: const Color(0xFF1A237E), // Warna rute
                        width: 5,
                      ),
                    },
                    // Marker untuk jemput, tujuan, dan lambang bus
                    markers: {
                      Marker(
                        markerId: const MarkerId('pickup_location'),
                        position: _pickupLocation,
                        infoWindow: InfoWindow(title: widget.origin),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                      ),
                      Marker(
                        markerId: const MarkerId('dropoff_location'),
                        position: _dropoffLocation,
                        infoWindow: InfoWindow(title: widget.destination),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      ),
                      if (busIcon != null && !_isLoadingRoute)
                        Marker(
                          markerId: const MarkerId('bus_unit_1'),
                          position: _busLocation,
                          icon: busIcon!, // Menggunakan lambang bus kustom
                          anchor: const Offset(0.5, 0.5),
                          infoWindow: InfoWindow(
                            title: "${widget.busName} - BK 882731",
                            snippet: "Lokasi Anda (Status: Perjalanan)",
                          ),
                        ),
                    },
                  ),
              
              // Card Info Panel 
              Positioned(
                bottom: 20, 
                left: 20, 
                right: 20, 
                child: _buildInfoCard(),
              ),
            ],
          )
        : _buildNoTrackingState(),
    );
  }

  // 1. TAMPILAN JIKA BELUM BOOKING (KOSONG)
  Widget _buildNoTrackingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.map_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text("Tidak Ada Perjalanan Aktif", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Anda hanya dapat melacak perjalanan jika memiliki tiket bus yang aktif pada hari ini.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF8E0E00),
              child: Icon(Icons.directions_bus, color: Colors.white),
            ),
            title: Text(widget.busName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("ID Booking: ${widget.bookingId}\nRute: ${widget.origin} - ${widget.destination}"),
            trailing: const Text("ON TIME", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            isThreeLine: true,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _dataItem(Icons.timer, "ETA", "45 Menit"),
              _dataItem(Icons.speed, "Speed", "65 km/jam"),
              _dataItem(Icons.map, "Jarak", "12.4 km"),
            ],
          )
        ],
      ),
    );
  }

  Widget _dataItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
