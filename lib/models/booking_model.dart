class Booking {
  final String id;
  final String busName;
  final String origin;
  final String destination;
  final String date;
  final int selectedSeatsCount;
  final List<String> seatNumbers;
  final double totalPrice;

  Booking({
    required this.id,
    required this.busName,
    required this.origin,
    required this.destination,
    required this.date,
    required this.selectedSeatsCount,
    required this.seatNumbers,
    required this.totalPrice,
  });
}
